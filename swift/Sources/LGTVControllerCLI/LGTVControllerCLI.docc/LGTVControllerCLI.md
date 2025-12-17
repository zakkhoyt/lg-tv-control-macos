# ``LGTVControllerCLI``

Command-line interface for controlling LG webOS TVs.

## Overview

The LGTVControllerCLI is a Swift port of the Python `lgtv` command-line tool. It provides a comprehensive set of commands for controlling LG webOS televisions from the terminal.

## Topics

### Getting Started

- <doc:UsingTheCLI>

### Command Categories

- Audio Commands
- Power Commands
- App Management
- Input Control

## Command Structure

All commands follow this pattern:

```bash
lgtv [options] <subcommand> [arguments]
```

### Global Options

- `--name NAME` or `-n NAME`: Specify the TV name (default: "LGC1")
- `--ssl`: Use secure WebSocket connection (wss)
- `--help`: Show help information
- `--version`: Show version information

## Example Commands

### Get Software Information

```bash
lgtv --name LGC1 --ssl sw-info
```

### Control Volume

```bash
lgtv --name LGC1 --ssl volume-up
lgtv --name LGC1 --ssl volume-down
```

### Power Off

```bash
lgtv --name LGC1 --ssl off
```

## Configuration

The CLI reads TV configurations from `~/.lgtv/lgtv/config/config.json`, maintaining compatibility with the Python `lgtv` tool.

## See Also

- [LGTVWebOSController Documentation](../LGTVWebOSController/documentation/lgtvweboscontroller)
