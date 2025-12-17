import Foundation
import ArgumentParser
import LGTVWebOSController

struct SwInfo: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Get software information")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://com.webos.service.update/getCurrentSWInformation")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct VolumeUp: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Increase volume")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://audio/volumeUp")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct VolumeDown: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Decrease volume")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://audio/volumeDown")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct Off: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Turn TV off")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://system/turnOff")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}
