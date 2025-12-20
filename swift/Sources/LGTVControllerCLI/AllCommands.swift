import Foundation
import ArgumentParser
import LGTVWebOSController

// MARK: - Additional Commands for Phase 5

// Information Commands
struct GetForegroundAppInfo: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Get current foreground app")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://com.webos.service.applicationmanager/getForegroundAppInfo")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct ListApps: TVCommand {
    static var configuration = CommandConfiguration(abstract: "List all installed apps")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://com.webos.service.applicationmanager/listApps")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct ListInputs: TVCommand {
    static var configuration = CommandConfiguration(abstract: "List available inputs")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://tv/getExternalInputList")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct GetSystemInfo: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Get system information")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://system/getSystemInfo")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct GetPowerState: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Get power state")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://com.webos.service.tvpower/power/getPowerState")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

// Input Control Commands
struct SetInput: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Switch to specific input")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    @Argument(help: "Input ID (e.g., HDMI_1, HDMI_2)") var inputId: String
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://tv/switchInput", payload: ["inputId": inputId])
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

// Volume Commands
struct SetVolume: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Set volume level")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    @Argument(help: "Volume level (0-100)") var volume: Int
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://audio/setVolume", payload: ["volume": volume])
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct Mute: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Mute or unmute")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    @Argument(help: "Mute state (true/false)") var muted: Bool
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://audio/setMute", payload: ["mute": muted])
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct AudioStatus: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Get audio status")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://audio/getStatus")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct AudioVolume: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Get current volume")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://audio/getVolume")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

// Screen Commands
struct ScreenOn: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Turn screen on")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://com.webos.service.tvpower/power/setPowerState", 
                                        payload: ["state": "Screen On"])
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct ScreenOff: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Turn screen off")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://com.webos.service.tvpower/power/setPowerState",
                                        payload: ["state": "Screen Off"])
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

// App Control Commands
struct StartApp: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Launch an app")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    @Argument(help: "App ID (e.g., com.webos.app.hdmi1)") var appId: String
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://system.launcher/launch", payload: ["id": appId])
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct CloseApp: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Close an app")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    @Argument(help: "App ID") var appId: String
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://system.launcher/close", payload: ["id": appId])
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

// Media Control Commands
struct InputMediaPlay: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Media play")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://media.controls/play")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct InputMediaPause: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Media pause")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://media.controls/pause")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct InputMediaStop: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Media stop")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://media.controls/stop")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct InputMediaRewind: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Media rewind")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://media.controls/rewind")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct InputMediaFastForward: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Media fast forward")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://media.controls/fastForward")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

// Channel Commands
struct ListChannels: TVCommand {
    static var configuration = CommandConfiguration(abstract: "List TV channels")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://tv/getChannelList")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct GetTVChannel: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Get current channel")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://tv/getCurrentChannel")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct SetTVChannel: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Change to channel")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    @Argument(help: "Channel ID") var channelId: String
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://tv/openChannel", payload: ["channelId": channelId])
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct InputChannelUp: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Channel up")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://tv/channelUp")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct InputChannelDown: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Channel down")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://tv/channelDown")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

// Utility Commands
struct OpenBrowserAt: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Open URL in TV browser")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    @Argument(help: "URL to open") var url: String
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://system.launcher/open",
                                        payload: ["target": url, "id": "com.webos.app.browser"])
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct Notification: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Show notification")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    @Argument(help: "Message to display") var message: String
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://system.notifications/createToast",
                                        payload: ["message": message])
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct ListServices: TVCommand {
    static var configuration = CommandConfiguration(abstract: "List available services")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        _ = try await client.sendCommand(uri: "ssap://api/getServiceList")
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

// YouTube Commands
struct OpenYoutubeURL: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Open YouTube video by URL")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    @Argument(help: "YouTube URL") var url: String
    
    func run() async throws {
        // Extract video ID from URL
        guard let videoId = extractYouTubeID(from: url) else {
            print("❌ Invalid YouTube URL")
            return
        }
        
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        
        _ = try await client.sendCommand(
            uri: "ssap://system.launcher/launch",
            payload: [
                "id": "youtube.leanback.v4",
                "contentId": videoId,
                "params": ["contentTarget": "https://www.youtube.com/tv?v=\(videoId)"]
            ]
        )
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
    
    private func extractYouTubeID(from urlString: String) -> String? {
        // Handle various YouTube URL formats
        if let range = urlString.range(of: "v=") {
            let afterV = urlString[range.upperBound...]
            if let endRange = afterV.range(of: "&") {
                return String(afterV[..<endRange.lowerBound])
            }
            return String(afterV)
        }
        
        if let range = urlString.range(of: "youtu.be/") {
            let afterSlash = urlString[range.upperBound...]
            if let endRange = afterSlash.range(of: "?") {
                return String(afterSlash[..<endRange.lowerBound])
            }
            return String(afterSlash)
        }
        
        return nil
    }
}

struct OpenYoutubeId: TVCommand {
    static var configuration = CommandConfiguration(abstract: "Open YouTube video by ID")
    @Option(name: [.customLong("name"), .short], help: "TV name") var name: String = "LGC1"
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss)") var useSSL: Bool = false
    @Argument(help: "YouTube video ID") var videoId: String
    
    func run() async throws {
        let client = try await createClient()
        defer { Task { await client.disconnect() } }
        
        _ = try await client.sendCommand(
            uri: "ssap://system.launcher/launch",
            payload: [
                "id": "youtube.leanback.v4",
                "contentId": videoId,
                "params": ["contentTarget": "https://www.youtube.com/tv?v=\(videoId)"]
            ]
        )
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}
