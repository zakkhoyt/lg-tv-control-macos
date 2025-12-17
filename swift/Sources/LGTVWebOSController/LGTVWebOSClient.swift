import Foundation
import NIO
import NIOFoundationCompat
import NIOSSL
import WebSocketKit

/// Response from the LG TV
public struct LGTVResponse: Codable {
    public let type: String
    public let id: String?
    public let payload: [String: AnyCodable]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case id
        case payload
    }
}

/// Helper for encoding/decoding dynamic JSON
public struct AnyCodable: Codable {
    public let value: Any
    
    public init(_ value: Any) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map { $0.value }
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            value = dictionary.mapValues { $0.value }
        } else {
            value = NSNull()
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch value {
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            try container.encode(array.map { AnyCodable($0) })
        case let dictionary as [String: Any]:
            try container.encode(dictionary.mapValues { AnyCodable($0) })
        case is NSNull:
            try container.encodeNil()
        default:
            try container.encodeNil()
        }
    }
}

/// WebSocket client for LG webOS TV
public final class LGTVWebOSClient: @unchecked Sendable {
    private let name: String
    private let ip: String
    private let mac: String?
    private let hostname: String?
    private let clientKey: String?
    private let useSSL: Bool
    
    private var ws: WebSocket?
    private var commandCount: Int = 0
    private var handshakeComplete: Bool = false
    private let eventLoopGroup: MultiThreadedEventLoopGroup
    
    public init(name: String, ip: String, mac: String? = nil, hostname: String? = nil, clientKey: String? = nil, useSSL: Bool = true) {
        self.name = name
        self.ip = ip
        self.mac = mac
        self.hostname = hostname
        self.clientKey = clientKey
        self.useSSL = useSSL
        self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    }
    
    deinit {
        try? eventLoopGroup.syncShutdownGracefully()
    }
    
    /// Connect to the TV
    public func connect() async throws {
        let port = useSSL ? 3001 : 3000
        let scheme = useSSL ? "wss" : "ws"
        let urlString = "\(scheme)://\(ip):\(port)/"
        
        guard let url = URL(string: urlString) else {
            throw LGTVError.invalidURL
        }
        
        var tlsConfiguration: TLSConfiguration?
        if useSSL {
            tlsConfiguration = TLSConfiguration.makeClientConfiguration()
            // Accept self-signed certificates from the TV
            tlsConfiguration?.certificateVerification = .none
        }
        
        let promise = eventLoopGroup.next().makePromise(of: WebSocket.self)
        
        WebSocket.connect(
            to: url,
            configuration: .init(
                tlsConfiguration: tlsConfiguration,
                maxFrameSize: 1 << 24
            ),
            on: eventLoopGroup
        ) { ws in
            promise.succeed(ws)
        }.cascadeFailure(to: promise)
        
        self.ws = try await promise.futureResult.get()
        
        // Setup message handler
        ws?.onText { [weak self] ws, text in
            self?.handleMessage(text)
        }
        
        // Perform handshake
        try await performHandshake()
    }
    
    /// Perform the initial handshake with the TV
    private func performHandshake() async throws {
        let helloPayload: [String: Any] = [
            "forcePairing": false,
            "pairingType": "PROMPT",
            "manifest": [
                "manifestVersion": 1,
                "appVersion": "1.0.0",
                "signed": [
                    "created": "20240101",
                    "appId": "com.lge.test",
                    "vendorId": "com.lge",
                    "localizedAppNames": [
                        "": "LG TV Controller",
                        "en-US": "LG TV Controller"
                    ],
                    "localizedVendorNames": [
                        "": "LG Electronics"
                    ],
                    "permissions": [
                        "TEST_SECURE",
                        "CONTROL_INPUT_TEXT",
                        "CONTROL_MOUSE_AND_KEYBOARD",
                        "READ_INSTALLED_APPS",
                        "READ_LGE_SDX",
                        "READ_NOTIFICATIONS",
                        "SEARCH",
                        "WRITE_SETTINGS",
                        "WRITE_NOTIFICATIONS",
                        "CONTROL_POWER",
                        "READ_CURRENT_CHANNEL",
                        "READ_RUNNING_APPS",
                        "READ_UPDATE_INFO",
                        "UPDATE_FROM_REMOTE_APP",
                        "READ_LGE_TV_INPUT_EVENTS",
                        "READ_TV_CURRENT_TIME"
                    ],
                    "serial": "12345"
                ]
            ]
        ]
        
        var payload = helloPayload
        if let clientKey = clientKey {
            payload["client-key"] = clientKey
        }
        
        let message: [String: Any] = [
            "type": "register",
            "id": "register_0",
            "payload": payload
        ]
        
        try await sendMessage(message)
        
        // Wait for handshake to complete
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        if !handshakeComplete {
            throw LGTVError.handshakeFailed
        }
    }
    
    /// Send a command to the TV
    public func sendCommand(type: String = "request", uri: String, payload: [String: Any]? = nil) async throws -> LGTVResponse? {
        guard handshakeComplete else {
            throw LGTVError.notConnected
        }
        
        commandCount += 1
        let commandId = "\(commandCount)"
        
        var message: [String: Any] = [
            "type": type,
            "id": commandId,
            "uri": uri
        ]
        
        if let payload = payload {
            message["payload"] = payload
        }
        
        try await sendMessage(message)
        
        // Wait for response
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        return nil
    }
    
    /// Send a raw message to the WebSocket
    private func sendMessage(_ message: [String: Any]) async throws {
        guard let ws = ws else {
            throw LGTVError.notConnected
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: message, options: [])
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw LGTVError.encodingFailed
        }
        
        try await ws.send(jsonString)
    }
    
    /// Handle incoming messages
    private func handleMessage(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let type = json["type"] as? String, type == "registered" {
                    handshakeComplete = true
                }
                
                // Print the response
                let prettyData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                if let prettyString = String(data: prettyData, encoding: .utf8) {
                    print(prettyString)
                }
            }
        } catch {
            print("Error parsing message: \(error)")
        }
    }
    
    /// Close the connection
    public func disconnect() async {
        try? await ws?.close().get()
        ws = nil
        handshakeComplete = false
    }
}

/// Errors that can occur when communicating with the TV
public enum LGTVError: Error {
    case invalidURL
    case notConnected
    case handshakeFailed
    case encodingFailed
}
