<!-- 

# TODO: zakkhoyt AI - Read this document in full,
then write a plan to be sent to a remote coding agent\x1B[1m
Write it to: /Users/zakkhoyt/code/repositories/z2k/github/lg-tv-control-macos/swift/SWIFT_PORT_PLAN.md

 -->


The goal here is to create an Xcode project that is a swift port of https://github.com/klattimer/LGWebOSRemote
IE: A command line tool to issue websockets commands to the TV, receive, decode, the print to stdout. 

The hammerspoon layer can come later in a phase 2 or 3. 


* a swift package  name `LGTVController`
* add a library target (LGTVWebOSController) 
  * Imlement code that can communicate with an LGC1 using a Websockets connection in the same way that this hammerspoon / python setup is doing
* add an executable target (mac command line tool w/swiftArgumentParser) 
  * This should mimic the python binary for `/opt/homebrew/bin/lgtv`
    * Other copies of that binary are available as .venv:
      * /Users/zakkhoyt/opt/lgtv/bin/lgtv
      * /Users/zakkhoyt/.lgtv/lgtv/bin/lgtv
* Here are some documents I've written abotu controlling my TV using the lgtv binary:
  * /Users/zakkhoyt/code/repositories/z2k/github/lg-tv-control-macos/docs/DEVELOPMENT.md
  * /Users/zakkhoyt/Documents/notes/lgtv/**/*
  * /Users/zakkhoyt/code/repositories/z2k/github/lg-tv-control-macos/.gitignored

* Repositories:
  * zakkhoyt/lg-tv-control-macos.git -> cmer/lg-tv-control-macos.git
  * https://github.com/klattimer/LGWebOSRemote

As for the websockets connection setup, I tried to set one up by hand in Swift but couldn't figure out the security configuration.


```help
$ lgtv --help
usage: lgtv [-h] [--name NAME] [--ssl] command [args ...]

LGTV Controller
Author: Karl Lattimer <karl@qdh.org.uk>

positional arguments:
  command
  args

options:
  -h, --help            show this help message and exit
  --name NAME, -n NAME
  --ssl

commands
 audioStatus
 audioVolume
 closeAlert <alertId>
 closeApp <appid>
 createAlert <message> <button>
 execute <command>
 getCursorSocket
 getForegroundAppInfo
 getPictureSettings
 getPowerState
 getSoundOutput
 getSystemInfo
 getTVChannel
 input3DOff
 input3DOn
 inputChannelDown
 inputChannelUp
 inputMediaFastForward
 inputMediaPause
 inputMediaPlay
 inputMediaRewind
 inputMediaStop
 listApps
 listChannels
 listInputs
 listLaunchPoints
 listServices
 mute <muted>
 notification <message>
 notificationWithIcon <message> <url>
 off
 on
 openAppWithPayload <payload>
 openBrowserAt <url>
 openYoutubeId <videoid>
 openYoutubeLegacyId <videoid>
 openYoutubeLegacyURL <url>
 openYoutubeURL <url>
 screenOff
 screenOn
 serialise
 setInput <input_id>
 setSoundOutput <output>
 setTVChannel <channel>
 setVolume <level>
 startApp <appid>
 swInfo
 volumeDown
 volumeUp
```