import Foundation

/// Manages loading and saving LG TV configurations
public class ConfigStore {
    private let configDirectory: URL
    
    /// Default config directory path: ~/.lgtv/lgtv/config
    public static let defaultConfigDirectory: URL = {
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
        return homeDirectory
            .appendingPathComponent(".lgtv")
            .appendingPathComponent("lgtv")
            .appendingPathComponent("config")
    }()
    
    public init(configDirectory: URL = ConfigStore.defaultConfigDirectory) {
        self.configDirectory = configDirectory
    }
    
    /// Load configuration for a specific TV by name
    /// - Parameter name: The name of the TV (e.g., "LGC1")
    /// - Returns: The configuration if found, nil otherwise
    public func loadConfig(name: String) -> LGTVConfig? {
        let configFile = configDirectory.appendingPathComponent("config.json")
        
        guard FileManager.default.fileExists(atPath: configFile.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: configFile)
            let decoder = JSONDecoder()
            
            // Try to decode as a single config
            if let config = try? decoder.decode(LGTVConfig.self, from: data), config.name == name {
                return config
            }
            
            // Try to decode as an array of configs
            if let configs = try? decoder.decode([LGTVConfig].self, from: data) {
                return configs.first { $0.name == name }
            }
            
            // Try to decode as a dictionary of configs
            if let configDict = try? decoder.decode([String: LGTVConfig].self, from: data) {
                return configDict[name]
            }
            
            return nil
        } catch {
            print("Error loading config: \(error)")
            return nil
        }
    }
    
    /// Load all configurations
    /// - Returns: Array of all TV configurations
    public func loadAllConfigs() -> [LGTVConfig] {
        let configFile = configDirectory.appendingPathComponent("config.json")
        
        guard FileManager.default.fileExists(atPath: configFile.path) else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: configFile)
            let decoder = JSONDecoder()
            
            // Try to decode as an array of configs
            if let configs = try? decoder.decode([LGTVConfig].self, from: data) {
                return configs
            }
            
            // Try to decode as a single config
            if let config = try? decoder.decode(LGTVConfig.self, from: data) {
                return [config]
            }
            
            // Try to decode as a dictionary of configs
            if let configDict = try? decoder.decode([String: LGTVConfig].self, from: data) {
                return Array(configDict.values)
            }
            
            return []
        } catch {
            print("Error loading configs: \(error)")
            return []
        }
    }
    
    /// Save a configuration
    /// - Parameter config: The configuration to save
    /// - Throws: Error if saving fails
    public func saveConfig(_ config: LGTVConfig) throws {
        // Ensure config directory exists
        try FileManager.default.createDirectory(at: configDirectory, withIntermediateDirectories: true, attributes: nil)
        
        let configFile = configDirectory.appendingPathComponent("config.json")
        
        // Load existing configs
        var configs = loadAllConfigs()
        
        // Update or add the config
        if let index = configs.firstIndex(where: { $0.name == config.name }) {
            configs[index] = config
        } else {
            configs.append(config)
        }
        
        // Write back to file
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(configs)
        try data.write(to: configFile)
    }
    
    /// Delete a configuration by name
    /// - Parameter name: The name of the TV configuration to delete
    /// - Throws: Error if deletion fails
    public func deleteConfig(name: String) throws {
        var configs = loadAllConfigs()
        configs.removeAll { $0.name == name }
        
        let configFile = configDirectory.appendingPathComponent("config.json")
        
        if configs.isEmpty {
            // Remove the config file if no configs remain
            try? FileManager.default.removeItem(at: configFile)
        } else {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(configs)
            try data.write(to: configFile)
        }
    }
}
