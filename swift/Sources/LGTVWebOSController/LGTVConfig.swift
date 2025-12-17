import Foundation

/// Configuration for an LG TV device
public struct LGTVConfig: Codable {
    /// Friendly name for the TV (e.g., "LGC1", "MyTV")
    public var name: String
    
    /// IP address of the TV
    public var ip: String
    
    /// Hostname of the TV (optional)
    public var hostname: String?
    
    /// MAC address of the TV (optional, used for Wake-on-LAN)
    public var mac: String?
    
    /// Client key obtained during pairing/authentication
    public var clientKey: String?
    
    public init(name: String, ip: String, hostname: String? = nil, mac: String? = nil, clientKey: String? = nil) {
        self.name = name
        self.ip = ip
        self.hostname = hostname
        self.mac = mac
        self.clientKey = clientKey
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case ip
        case hostname
        case mac
        case clientKey = "client-key"
    }
}
