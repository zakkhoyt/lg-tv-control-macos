import Foundation
import ArgumentParser
import LGTVWebOSController

@main
struct LGTVControllerCLI: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "lgtv",
        abstract: "LGTV Controller (Swift port skeleton)",
        discussion: "A work-in-progress Swift port of the LGWebOSRemote lgtv CLI.",
        version: "0.1.0"
    )

    @Option(name: [.customLong("name"), .short], help: "TV name (for future config lookup).")
    var name: String = "LGC1"

    @Flag(name: .customLong("ssl"), help: "Use SSL (wss) to connect to the TV.")
    var useSSL: Bool = false

    func run() throws {
        // For now, just exercise the library stub so the binary is useful.
        let client = LGTVWebOSClient()
        client.ping()
        print("(Swift CLI stub) name=\(name) useSSL=\(useSSL)")
    }
}
