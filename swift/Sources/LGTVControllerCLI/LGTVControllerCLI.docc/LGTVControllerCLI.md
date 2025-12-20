# ``LGTVControllerCLI``

Command-line interface for controlling LG webOS TVs.

## Overview

The LGTVControllerCLI is a Swift port of the Python `lgtv` command-line tool. It provides a comprehensive set of commands for controlling LG webOS televisions from the terminal.

## Getting Started

New to the CLI? Start here:

1. Run `lgtv setup` for interactive setup guide
2. Run `lgtv scan --ssl` to discover your TV
3. Run `lgtv auth <IP> <NAME> --ssl` to pair with your TV
4. Run `lgtv sw-info --name <NAME> --ssl` to test

## Topics

### Setup and Configuration

- <doc:SetupGuide>
- <doc:UsingTheCLI>

### Command Categories

#### Discovery & Setup
- `setup` - Interactive setup guide
- `scan` - Find TVs on network
- `auth` - Pair with a TV

#### Information Commands
- `sw-info` - Software information
- `get-foreground-app-info` - Current app
- `get-system-info` - System details
- `get-power-state` - Power status
- `list-apps` - Installed apps
- `list-inputs` - Available inputs
- `list-channels` - TV channels
- `list-services` - Available services

#### Volume Control
- `volume-up` / `volume-down` - Adjust volume
- `set-volume` - Set specific level
- `mute` - Mute/unmute
- `audio-status` - Audio information
- `audio-volume` - Current volume

#### Power Control
- `off` - Turn TV off
- `screen-on` / `screen-off` - Screen power

#### Input & Channel Control
- `set-input` - Switch input
- `input-channel-up` / `input-channel-down` - Change channel
- `set-tv-channel` - Go to specific channel

#### App Management
- `start-app` - Launch app
- `close-app` - Close app

#### Media Control
- `input-media-play` / `input-media-pause` - Playback control
- `input-media-stop` - Stop playback
- `input-media-rewind` / `input-media-fast-forward` - Seek

#### Utilities
- `open-browser-at` - Open URL in browser
- `notification` - Show notification
- `open-youtube-url` - Play YouTube video
- `open-youtube-id` - Play YouTube by ID

## Command Structure

All commands follow this pattern:

```bash
lgtv <subcommand> [arguments] [--name NAME] [--ssl]
```

### Global Options

- `--name NAME` or `-n NAME`: Specify the TV name (default: "LGC1")
- `--ssl`: Use secure WebSocket connection (wss)
- `--help`: Show help information
- `--version`: Show version information

## Example Commands

### Setup and Discovery

```bash
# Interactive setup guide
lgtv setup

# Scan for TVs
lgtv scan --ssl

# Pair with TV
lgtv auth 192.168.1.100 MyTV --ssl
```

### Basic Control

```bash
# Get software information
lgtv sw-info --name MyTV --ssl

# Control volume
lgtv volume-up --name MyTV --ssl
lgtv volume-down --name MyTV --ssl
lgtv set-volume 25 --name MyTV --ssl

# Power control
lgtv off --name MyTV --ssl
lgtv screen-off --name MyTV --ssl
```

### Advanced Usage

```bash
# Switch input
lgtv set-input HDMI_1 --name MyTV --ssl

# Launch app
lgtv start-app com.webos.app.hdmi1 --name MyTV --ssl

# Open YouTube
lgtv open-youtube-url "https://youtube.com/watch?v=dQw4w9WgXcQ" --name MyTV --ssl

# Show notification
lgtv notification "Hello from Mac!" --name MyTV --ssl
```

## Configuration

The CLI reads TV configurations from `~/.lgtv/lgtv/config/config.json`, maintaining compatibility with the Python `lgtv` tool.

**Example Configuration:**
```json
[
  {
    "name": "MyTV",
    "ip": "192.168.1.100",
    "client-key": "abc123def456",
    "mac": "aa:bb:cc:dd:ee:ff"
  }
]
```

## See Also

- [LGTVWebOSController Documentation](../LGTVWebOSController/documentation/lgtvweboscontroller)
- <doc:SetupGuide>
- <doc:UsingTheCLI>
