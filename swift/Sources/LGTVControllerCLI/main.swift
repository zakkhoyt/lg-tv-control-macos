import ArgumentParser

@available(macOS 10.15, *)
struct LGTVControllerCLI: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "lgtv",
        abstract: "LGTV Controller",
        discussion: "A Swift port of the LGWebOSRemote lgtv CLI",
        version: "0.1.0",
        subcommands: [
            SwInfo.self,
            VolumeUp.self,
            VolumeDown.self,
            Off.self
        ]
    )
}

LGTVControllerCLI.main()
