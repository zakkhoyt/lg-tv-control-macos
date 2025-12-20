import Foundation
import ArgumentParser
import LGTVWebOSController

// MARK: - Auth Command

struct Auth: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Pair with a TV and save credentials",
        discussion: """
        Authenticate and pair with an LG webOS TV. This command will:
        1. Connect to the TV at the specified IP address
        2. Prompt you to accept the pairing request on your TV screen
        3. Save the authentication key to ~/.lgtv/lgtv/config/config.json
        
        Example: lgtv auth 192.168.1.100 LivingRoomTV --ssl
        """
    )
    
    @Argument(help: "IP address of the TV (e.g., 192.168.1.100)")
    var ipAddress: String
    
    @Argument(help: "Friendly name for the TV (e.g., LivingRoomTV, LGC1)")
    var tvName: String
    
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss) connection")
    var useSSL: Bool = false
    
    func run() async throws {
        print("🔗 Connecting to TV at \(ipAddress)...")
        print("📺 TV Name: \(tvName)")
        print("🔒 SSL: \(useSSL ? "enabled" : "disabled")")
        print()
        
        // Create client without client key for initial pairing
        let client = LGTVWebOSClient(
            name: tvName,
            ip: ipAddress,
            mac: nil,
            hostname: nil,
            clientKey: nil,
            useSSL: useSSL
        )
        
        do {
            print("⏳ Establishing connection...")
            try await client.connect()
            
            print()
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print("📱 PAIRING REQUEST SENT TO YOUR TV")
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print()
            print("👉 Please look at your TV screen now!")
            print("   A pairing request dialog should appear.")
            print()
            print("✅ Press 'Allow' or 'OK' on your TV remote to complete pairing.")
            print()
            print("⏱  Waiting for your response (this may take up to 30 seconds)...")
            print()
            
            // Wait for pairing to complete
            // The handshake in the client will handle the registered response
            try await Task.sleep(nanoseconds: 5_000_000_000) // 5 seconds
            
            // Try to get MAC address from ARP
            let macAddress = try? getMacAddress(for: ipAddress)
            
            // Save configuration
            let config = LGTVConfig(
                name: tvName,
                ip: ipAddress,
                hostname: nil,
                mac: macAddress,
                clientKey: client.currentClientKey
            )
            
            let store = ConfigStore()
            try store.saveConfig(config)
            
            print()
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print("✨ PAIRING SUCCESSFUL!")
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print()
            print("📁 Configuration saved to: ~/.lgtv/lgtv/config/config.json")
            if let mac = macAddress {
                print("🔧 MAC Address detected: \(mac)")
            }
            if let key = client.currentClientKey {
                print("🔑 Client key saved: \(key)")
            }
            print()
            print("🎉 You can now control your TV with commands like:")
            print("   lgtv sw-info --name \(tvName)\(useSSL ? " --ssl" : "")")
            print("   lgtv volume-up --name \(tvName)\(useSSL ? " --ssl" : "")")
            print("   lgtv off --name \(tvName)\(useSSL ? " --ssl" : "")")
            print()
            
            await client.disconnect()
            
        } catch {
            print()
            print("❌ Pairing failed: \(error)")
            print()
            print("💡 Troubleshooting tips:")
            print("   1. Make sure your TV is powered on")
            print("   2. Verify the IP address is correct")
            print("   3. Ensure your computer and TV are on the same network")
            print("   4. Try with or without the --ssl flag")
            print()
            throw error
        }
    }
    
    private func getMacAddress(for ip: String) throws -> String? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/sbin/arp")
        process.arguments = ["-n", ip]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        try process.run()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8) else { return nil }
        
        // Parse ARP output for MAC address
        // Format: "? (192.168.1.100) at aa:bb:cc:dd:ee:ff on en0 ifscope [ethernet]"
        let lines = output.components(separatedBy: .newlines)
        for line in lines {
            if line.contains(ip) {
                let components = line.components(separatedBy: " ")
                for (index, component) in components.enumerated() {
                    if component == "at", index + 1 < components.count {
                        let mac = components[index + 1]
                        if mac.contains(":") {
                            return mac
                        }
                    }
                }
            }
        }
        
        return nil
    }
}

// MARK: - Scan Command

struct Scan: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Scan for LG TVs on the local network",
        discussion: """
        Discover LG webOS TVs on your local network. This command will:
        1. Scan common IP ranges for TVs
        2. Attempt to connect to each potential TV
        3. Display discovered TVs with their details
        
        Example: lgtv scan --ssl
        """
    )
    
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss) when testing connections")
    var useSSL: Bool = false
    
    func run() async throws {
        print("🔍 Scanning for LG webOS TVs on local network...")
        print("🔒 SSL: \(useSSL ? "enabled" : "disabled")")
        print()
        
        // Get local network info
        guard let localIP = getLocalIPAddress() else {
            print("❌ Could not determine local IP address")
            print("💡 Make sure you're connected to a network")
            return
        }
        
        print("📡 Local IP: \(localIP)")
        
        // Extract network prefix (e.g., "192.168.1" from "192.168.1.100")
        let components = localIP.components(separatedBy: ".")
        guard components.count == 4 else {
            print("❌ Invalid IP address format")
            return
        }
        
        let networkPrefix = "\(components[0]).\(components[1]).\(components[2])"
        print("🌐 Scanning network: \(networkPrefix).0/24")
        print()
        
        var foundTVs: [(ip: String, info: String)] = []
        
        // Common TV IPs to check first (last octet)
        let commonIPs = [100, 101, 102, 110, 150, 200, 10, 20, 50]
        
        print("⏳ Checking common IP addresses...")
        
        for lastOctet in commonIPs {
            let testIP = "\(networkPrefix).\(lastOctet)"
            if let info = await testTV(ip: testIP, useSSL: useSSL) {
                foundTVs.append((testIP, info))
                print("   ✅ Found TV at \(testIP)")
            }
        }
        
        print()
        
        if foundTVs.isEmpty {
            print("❌ No TVs found")
            print()
            print("💡 Troubleshooting:")
            print("   1. Make sure your TV is powered on")
            print("   2. Verify your TV is connected to the same network")
            print("   3. Check if your TV's network settings show an IP address")
            print("   4. Try scanning with --ssl or without it")
            print()
        } else {
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print("📺 FOUND \(foundTVs.count) TV(S)")
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print()
            
            for (ip, info) in foundTVs {
                print("IP Address: \(ip)")
                print("Info: \(info)")
                print()
                print("To pair with this TV:")
                print("  lgtv auth \(ip) MyTV\(useSSL ? " --ssl" : "")")
                print()
                print("────────────────────────────────────────────────")
                print()
            }
        }
    }
    
    private func testTV(ip: String, useSSL: Bool) async -> String? {
        do {
            let client = LGTVWebOSClient(
                name: "scan",
                ip: ip,
                mac: nil,
                hostname: nil,
                clientKey: nil,
                useSSL: useSSL
            )
            
            try await client.connect()
            
            // If we got here, it's likely a TV
            await client.disconnect()
            
            return "LG webOS TV (connection successful)"
        } catch {
            return nil
        }
    }
    
    private func getLocalIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            let addrFamily = interface.ifa_addr.pointee.sa_family
            
            if addrFamily == UInt8(AF_INET) {
                let name = String(cString: interface.ifa_name)
                
                // Check for active network interfaces (not loopback)
                if name == "en0" || name == "en1" {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    
                    // Get the sockaddr size based on address family
                    let addrSize: socklen_t
                    if addrFamily == UInt8(AF_INET) {
                        addrSize = socklen_t(MemoryLayout<sockaddr_in>.size)
                    } else if addrFamily == UInt8(AF_INET6) {
                        addrSize = socklen_t(MemoryLayout<sockaddr_in6>.size)
                    } else {
                        continue
                    }
                    
                    if getnameinfo(interface.ifa_addr,
                                 addrSize,
                                 &hostname,
                                 socklen_t(hostname.count),
                                 nil,
                                 socklen_t(0),
                                 NI_NUMERICHOST) == 0 {
                        address = String(cString: hostname)
                    }
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return address
    }
}

// MARK: - Setup Guide Command

struct Setup: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Interactive setup guide",
        discussion: "Step-by-step guide to set up and configure your LG TV for control"
    )
    
    func run() throws {
        print()
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("📺 LG TV Control - Setup Guide")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print()
        
        printStep(1, "Prerequisites", """
        Before you begin, ensure:
        
        ✓ Your LG TV is powered ON
        ✓ Your TV is connected to your network (WiFi or Ethernet)
        ✓ Your Mac is on the SAME network as your TV
        ✓ You have your TV remote handy (for pairing approval)
        """)
        
        printStep(2, "Check TV Network Settings", """
        On your LG TV:
        
        1. Press the Settings button on your remote
        2. Navigate to: Network → Network Status (or WiFi Connection)
        3. Note your TV's IP address (e.g., 192.168.1.100)
        4. Ensure it shows "Connected to Internet"
        
        📝 Write down the IP address - you'll need it for pairing!
        """)
        
        printStep(3, "Network Connection", """
        ┌─────────────────────────────────────────────────┐
        │  Recommended: Ethernet Connection               │
        │  • More reliable for automation                 │
        │  • Static IP can be configured                  │
        │  • No WiFi sleep issues                         │
        └─────────────────────────────────────────────────┘
        
        ┌─────────────────────────────────────────────────┐
        │  WiFi Connection                                │
        │  • Ensure TV doesn't sleep/disconnect           │
        │  • May need to disable "WiFi Power Saving"     │
        │  • IP address might change (use hostname)       │
        └─────────────────────────────────────────────────┘
        """)
        
        printStep(4, "Discover Your TV", """
        Run the scan command to find your TV:
        
        $ lgtv scan --ssl
        
        This will search your local network for LG TVs.
        If found, it will display the IP address.
        
        💡 If scan doesn't find your TV, you can still use the IP
           address you noted from the TV's network settings.
        """)
        
        printStep(5, "Pair with Your TV", """
        Use the auth command with your TV's IP:
        
        $ lgtv auth <IP_ADDRESS> <TV_NAME> --ssl
        
        Example:
        $ lgtv auth 192.168.1.100 LivingRoom --ssl
        
        What happens:
        • A pairing request appears on your TV screen
        • Use your TV remote to select "Allow" or "OK"
        • Authentication key is saved automatically
        
        ⚡ The --ssl flag is recommended for secure communication.
        """)
        
        printStep(6, "Test Your Connection", """
        Try these commands to verify everything works:
        
        # Get TV software info
        $ lgtv sw-info --name LivingRoom --ssl

        # Control volume
        $ lgtv volume-up --name LivingRoom --ssl
        $ lgtv volume-down --name LivingRoom --ssl

        # Power control
        $ lgtv off --name LivingRoom --ssl
        $ lgtv screen-off --name LivingRoom --ssl
        """)
        
        printStep(7, "HDMI-CEC Considerations", """
        For HDMI-connected Macs:
        
        ✓ Enable HDMI-CEC on your TV (Settings → General → HDMI-CEC)
        ✓ This allows TV to detect Mac power state
        ✓ TV can auto-switch inputs when Mac wakes
        
        Note: CEC behavior varies by TV model and settings.
        """)
        
        printStep(8, "macOS Automation (Optional)", """
        You can automate TV control with:
        
        • Hammerspoon: Monitor Mac sleep/wake events
        • Shell scripts: Create custom automation
        • Keyboard shortcuts: Use macOS Shortcuts app
        
        Example shell alias in ~/.zshrc or ~/.bashrc:
        
        alias tv-on='lgtv screen-on --name LivingRoom --ssl'
        alias tv-off='lgtv screen-off --name LivingRoom --ssl'
        """)
        
        print()
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("📚 Additional Resources")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print()
        print("• List all commands: lgtv --help")
        print("• Command help: lgtv <command> --help")
        print("• Config location: ~/.lgtv/lgtv/config/config.json")
        print()
        print("🎉 Setup complete! Enjoy controlling your LG TV from the command line!")
        print()
    }
    
    private func printStep(_ number: Int, _ title: String, _ content: String) {
        print("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("┃ Step \(number): \(title)")
        print("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print()
        
        let lines = content.components(separatedBy: .newlines)
        for line in lines {
            print(line)
        }
        
        print()
    }
}
