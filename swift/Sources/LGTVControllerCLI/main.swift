import Foundation
import ArgumentParser
import LGTVWebOSController

@main
struct LGTVControllerCLI: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "lgtv",
        abstract: "LGTV Controller",
        discussion: "A Swift port of the LGWebOSRemote lgtv CLI.",
        version: "0.1.0",
        subcommands: [
            SwInfo.self,
            GetForegroundAppInfo.self,
            ListApps.self,
            ListInputs.self,
            SetInput.self,
            VolumeUp.self,
            VolumeDown.self,
            SetVolume.self,
            Mute.self,
            On.self,
            Off.self,
            ScreenOn.self,
            ScreenOff.self,
            StartApp.self
        ]
    )
}

// MARK: - Common Options

protocol TVCommand: AsyncParsableCommand {
    var name: String { get set }
    var useSSL: Bool { get set }
}

extension TVCommand {
    func loadConfig() throws -> LGTVConfig? {
        let configStore = ConfigStore()
        return configStore.loadConfig(name: name)
    }
    
    func createClient() async throws -> LGTVWebOSClient {
        guard let config = try loadConfig() else {
            throw LGTVCLIError.configNotFound(name: name)
        }
        
        let client = LGTVWebOSClient(
            name: config.name,
            ip: config.ip,
            mac: config.mac,
            hostname: config.hostname,
            clientKey: config.clientKey,
            useSSL: useSSL
        )
        
        try await client.connect()
        return client
    }
}

// MARK: - Commands

struct SwInfo: TVCommand {
    static var configuration = CommandConfiguration(
        abstract: "Get software information"
    )
    
    @Option(name: [.customLong("name"), .short], help: "TV name")
    var name: String = "LGC1"
    
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)")
    var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer {
            Task {
                await client.disconnect()
            }
        }
        
        _ = try await client.sendCommand(
            uri: "ssap://com.webos.service.update/getCurrentSWInformation"
        )
        
        // Wait for response to be printed
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct GetForegroundAppInfo: TVCommand {
    static var configuration = CommandConfiguration(
        abstract: "Get foreground app information"
    )
    
    @Option(name: [.customLong("name"), .short], help: "TV name")
    var name: String = "LGC1"
    
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)")
    var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer {
            Task {
                await client.disconnect()
            }
        }
        
        _ = try await client.sendCommand(
            uri: "ssap://com.webos.service.applicationmanager/getForegroundAppInfo"
        )
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct ListApps: TVCommand {
    static var configuration = CommandConfiguration(
        abstract: "List installed apps"
    )
    
    @Option(name: [.customLong("name"), .short], help: "TV name")
    var name: String = "LGC1"
    
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)")
    var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer {
            Task {
                await client.disconnect()
            }
        }
        
        _ = try await client.sendCommand(
            uri: "ssap://com.webos.service.applicationmanager/listApps"
        )
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct ListInputs: TVCommand {
    static var configuration = CommandConfiguration(
        abstract: "List available inputs"
    )
    
    @Option(name: [.customLong("name"), .short], help: "TV name")
    var name: String = "LGC1"
    
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)")
    var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer {
            Task {
                await client.disconnect()
            }
        }
        
        _ = try await client.sendCommand(
            uri: "ssap://tv/getExternalInputList"
        )
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct SetInput: TVCommand {
    static var configuration = CommandConfiguration(
        abstract: "Set input source"
    )
    
    @Option(name: [.customLong("name"), .short], help: "TV name")
    var name: String = "LGC1"
    
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)")
    var useSSL: Bool = false
    
    @Argument(help: "Input ID (e.g., HDMI_1)")
    var inputId: String
    
    func run() async throws {
        let client = try await createClient()
        defer {
            Task {
                await client.disconnect()
            }
        }
        
        _ = try await client.sendCommand(
            uri: "ssap://tv/switchInput",
            payload: ["inputId": inputId]
        )
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct VolumeUp: TVCommand {
    static var configuration = CommandConfiguration(
        abstract: "Increase volume"
    )
    
    @Option(name: [.customLong("name"), .short], help: "TV name")
    var name: String = "LGC1"
    
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)")
    var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer {
            Task {
                await client.disconnect()
            }
        }
        
        _ = try await client.sendCommand(
            uri: "ssap://audio/volumeUp"
        )
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct VolumeDown: TVCommand {
    static var configuration = CommandConfiguration(
        abstract: "Decrease volume"
    )
    
    @Option(name: [.customLong("name"), .short], help: "TV name")
    var name: String = "LGC1"
    
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)")
    var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer {
            Task {
                await client.disconnect()
            }
        }
        
        _ = try await client.sendCommand(
            uri: "ssap://audio/volumeDown"
        )
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct SetVolume: TVCommand {
    static var configuration = CommandConfiguration(
        abstract: "Set volume level"
    )
    
    @Option(name: [.customLong("name"), .short], help: "TV name")
    var name: String = "LGC1"
    
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)")
    var useSSL: Bool = false
    
    @Argument(help: "Volume level (0-100)")
    var volume: Int
    
    func run() async throws {
        let client = try await createClient()
        defer {
            Task {
                await client.disconnect()
            }
        }
        
        _ = try await client.sendCommand(
            uri: "ssap://audio/setVolume",
            payload: ["volume": volume]
        )
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct Mute: TVCommand {
    static var configuration = CommandConfiguration(
        abstract: "Mute or unmute"
    )
    
    @Option(name: [.customLong("name"), .short], help: "TV name")
    var name: String = "LGC1"
    
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)")
    var useSSL: Bool = false
    
    @Argument(help: "Mute state (true/false)")
    var muted: Bool
    
    func run() async throws {
        let client = try await createClient()
        defer {
            Task {
                await client.disconnect()
            }
        }
        
        _ = try await client.sendCommand(
            uri: "ssap://audio/setMute",
            payload: ["mute": muted]
        )
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct On: TVCommand {
    static var configuration = CommandConfiguration(
        abstract: "Turn TV on (via Wake-on-LAN)"
    )
    
    @Option(name: [.customLong("name"), .short], help: "TV name")
    var name: String = "LGC1"
    
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)")
    var useSSL: Bool = false
    
    func run() async throws {
        guard let config = try loadConfig() else {
            throw LGTVCLIError.configNotFound(name: name)
        }
        
        guard let mac = config.mac else {
            throw LGTVCLIError.macAddressRequired
        }
        
        // TODO: Implement Wake-on-LAN
        print("Wake-on-LAN not yet implemented for MAC: \(mac)")
    }
}

struct Off: TVCommand {
    static var configuration = CommandConfiguration(
        abstract: "Turn TV off"
    )
    
    @Option(name: [.customLong("name"), .short], help: "TV name")
    var name: String = "LGC1"
    
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)")
    var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer {
            Task {
                await client.disconnect()
            }
        }
        
        _ = try await client.sendCommand(
            uri: "ssap://system/turnOff"
        )
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct ScreenOn: TVCommand {
    static var configuration = CommandConfiguration(
        abstract: "Turn screen on"
    )
    
    @Option(name: [.customLong("name"), .short], help: "TV name")
    var name: String = "LGC1"
    
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)")
    var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer {
            Task {
                await client.disconnect()
            }
        }
        
        _ = try await client.sendCommand(
            uri: "ssap://com.webos.service.tvpower/power/setPowerState",
            payload: ["state": "Screen On"]
        )
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct ScreenOff: TVCommand {
    static var configuration = CommandConfiguration(
        abstract: "Turn screen off"
    )
    
    @Option(name: [.customLong("name"), .short], help: "TV name")
    var name: String = "LGC1"
    
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)")
    var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer {
            Task {
                await client.disconnect()
            }
        }
        
        _ = try await client.sendCommand(
            uri: "ssap://com.webos.service.tvpower/power/setPowerState",
            payload: ["state": "Screen Off"]
        )
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct StartApp: TVCommand {
    static var configuration = CommandConfiguration(
        abstract: "Start an app"
    )
    
    @Option(name: [.customLong("name"), .short], help: "TV name")
    var name: String = "LGC1"
    
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)")
    var useSSL: Bool = false
    
    @Argument(help: "App ID (e.g., com.webos.app.hdmi1)")
    var appId: String
    
    func run() async throws {
        let client = try await createClient()
        defer {
            Task {
                await client.disconnect()
            }
        }
        
        _ = try await client.sendCommand(
            uri: "ssap://system.launcher/launch",
            payload: ["id": appId]
        )
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

// MARK: - Errors

enum LGTVCLIError: Error, CustomStringConvertible {
    case configNotFound(name: String)
    case macAddressRequired
    
    var description: String {
        switch self {
        case .configNotFound(let name):
            return "Configuration not found for TV '\(name)'. Please run auth first."
        case .macAddressRequired:
            return "MAC address is required for Wake-on-LAN. Please add it to the config."
        }
    }
}
