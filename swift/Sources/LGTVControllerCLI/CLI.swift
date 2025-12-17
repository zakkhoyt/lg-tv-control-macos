import Foundation
import ArgumentParser
import LGTVWebOSController

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
