import ArgumentParser

@available(macOS 10.15, macCatalyst 13, iOS 13, tvOS 13, watchOS 6, *)
struct LGTVControllerCLI: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "lgtv",
        abstract: "LGTV Controller",
        discussion: """
        Control your LG webOS TV from the command line.
        
        Quick Start:
          1. Run 'lgtv setup' for step-by-step setup guide
          2. Run 'lgtv scan --ssl' to find your TV
          3. Run 'lgtv auth <IP> <NAME> --ssl' to pair with your TV
          4. Run 'lgtv --name <NAME> --ssl sw-info' to test connection
        """,
        version: "0.1.0",
        subcommands: [
            // Setup & Discovery
            Setup.self,
            Scan.self,
            Auth.self,
            
            // Information
            SwInfo.self,
            GetForegroundAppInfo.self,
            GetSystemInfo.self,
            GetPowerState.self,
            ListApps.self,
            ListInputs.self,
            ListChannels.self,
            GetTVChannel.self,
            ListServices.self,
            
            // Volume Control
            VolumeUp.self,
            VolumeDown.self,
            SetVolume.self,
            Mute.self,
            AudioStatus.self,
            AudioVolume.self,
            
            // Power Control
            Off.self,
            ScreenOn.self,
            ScreenOff.self,
            
            // Input Control
            SetInput.self,
            InputChannelUp.self,
            InputChannelDown.self,
            SetTVChannel.self,
            
            // App Control
            StartApp.self,
            CloseApp.self,
            
            // Media Control
            InputMediaPlay.self,
            InputMediaPause.self,
            InputMediaStop.self,
            InputMediaRewind.self,
            InputMediaFastForward.self,
            
            // Utilities
            OpenBrowserAt.self,
            Notification.self,
            OpenYoutubeURL.self,
            OpenYoutubeId.self
        ]
    )
}
