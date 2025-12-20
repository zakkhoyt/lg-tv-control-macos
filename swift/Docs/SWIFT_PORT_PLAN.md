
<!-- 
# TODO: zakkhoyt AI - This document outlines plans to create a Swift package with a couple of targets (no Xcode required)
Read the full document then implement through phase 6
 -->

## Swift Port Plan: LGTVController / LGTVWebOSController

This plan is for a remote coding agent to create a Swift port of klattimer/LGWebOSRemote, focused on a macOS command‑line tool that speaks to an LG C1 TV over WebSockets (wss) and mimics the existing `lgtv` Python CLI.

Repository: `cmer/lg-tv-control-macos` (branch: `zakk/2024`)
Working dir: `swift/`

Targets:
- Swift Package: `LGTVController`
- Library target: `LGTVWebOSController`
- Executable target: `lgtv-swift` (name can be refined later, but should roughly mirror the Python `lgtv` interface)

Constraints / Notes:
- Phase 1: implement a working Swift CLI + library that talks to a single LG C1 using the existing config & key material (or a compatible scheme).
- Phase 2/3 (out of scope here): Hammerspoon integration and any macOS GUI niceties.
- The Python reference implementation to mirror is klattimer/LGWebOSRemote, especially LGTV/auth.py, LGTV/remote.py, LGTV/main.py.
- The CLI behavior should match the Python `lgtv` tool as closely as is reasonable.

---

### Phase 0 – Project & Package Setup

1. Create Swift Package
	 - From `swift/`, run `swift package init --type executable` and rename/restructure to the following layout:
		 - Package name: `LGTVController`.
		 - Library target: `LGTVWebOSController`.
		 - Executable target: `LGTVControllerCLI` (binary name configurable to `lgtv` later).
	 - Ensure the package builds on macOS with the system toolchain (Swift 5.x+).

2. Update Package.swift
	 - Add dependency on `apple/swift-argument-parser` for CLI parsing.
	 - Add dependency on a WebSocket implementation that works on macOS with TLS (wss):
		 - Preferred: `apple/swift-nio` + `swift-nio-ssl` + `swift-nio-websocket`.
		 - Acceptable alternative: a simpler WebSocket package that supports `wss://` with custom TLS settings.
	 - Define products/targets:
		 - `.library(name: "LGTVWebOSController", targets: ["LGTVWebOSController"])`
		 - `.executable(name: "lgtv", targets: ["LGTVControllerCLI"])`


Deliverables for Phase 0:
- A compiling Swift package with stubbed library + executable targets and working `--help` output.

---

### Phase 1 – Config & Data Model

Goal: Mirror the Python tool’s configuration and basic data structures so that the Swift code knows where to connect and what key to use.

1. Configuration File Strategy
	 - Reference Python behavior:
		 - Python uses a JSON config under `~/.lgtv` (see docs and LGWebOSRemote).
	 - Decide for Swift:
		 - Either reuse the existing config file format and path for maximum interoperability.
		 - Or, if necessary, define a very similar JSON structure (same keys: name, ip, hostname, mac, client-key) under the same directory.

2. Implement Config Model in Swift
	 - Add a `LGTVConfig` struct conforming to `Codable`:
		 - Fields: `name`, `ip`, `hostname`, `mac`, `clientKey` (string), etc.
	 - Add `ConfigStore` helper:
		 - Resolves the config path (e.g. `~/.lgtv/lgtv/config/config.json` or equivalent from current Python setup).
		 - Provides `loadConfig(name: String) -> LGTVConfig?` and `saveConfig(_:)` APIs.

3. Map Python Serialisation
	 - Mirror `serialise()` from LGTVRemote and LGTVAuth:
		 - Ensure the JSON written by Swift matches the shape used by Python where practical.
	 - Confirm that when Swift writes config, Python can still read/use it (nice-to-have, not absolutely required).

Deliverables for Phase 1:
- Codable config types and load/save logic.
- Minimal unit-style checks or simple test harness to confirm reading/writing JSON config.

---

### Phase 2 – WebSocket Client & Handshake

Goal: Implement a Swift WebSocket client that handles the LG webOS pairing/handshake and sends commands, equivalent to LGTVRemote in Python.

1. Define Core Types
	 - `LGTVWebOSClient` class/struct in the `LGTVWebOSController` target:
		 - Initializer parameters similar to Python’s LGTVRemote:
			 - `name: String`
			 - `ip: String?`
			 - `mac: String?`
			 - `hostname: String?`
			 - `clientKey: String?`
			 - `useSSL: Bool` (maps to `--ssl` flag).
	 - Internal state:
		 - Command queue, command counter, `waitingCallback`, handshake‑done flag.
		 - WebSocket connection instance (NIO- or framework-specific type).

2. TLS / WebSocket Setup
	 - Implement connection logic:
		 - For non‑SSL: `ws://<ip>:3000/`.
		 - For SSL: `wss://<ip>:3001/`.
	 - TLS configuration:
		 - Configure trust policy to accept the TV’s certificate (often self‑signed):
			 - Relaxed certificate checking, but *only* for the TV’s host/IP.
			 - Document that security is limited to LAN usage.
	 - Implement automatic hostname → IP resolution like Python’s LGTVRemote does.

3. Handshake / Registration
	 - Port the `hello_data` payload (from Python `payload.py`) into Swift:
		 - Add a Swift type or static JSON template with `client-key` field.
	 - Implement handshake sequence:
		 - On connect, send `hello_data` with `client-key` from config.
		 - Wait for a `registered` response; mark handshake complete.
		 - For responses that do not contain `client-key`, forward to the waiting command handler.

4. Request/Response Handling
	 - Implement `sendCommand(type: String, uri: String, payload: [String: Any]?, callback: (LGTVResponse) -> Void)`:
		 - Construct message JSON with `id`, `type`, `uri`, optional `payload`.
		 - Maintain `commandCount` for IDs; support optional prefixes like Python (e.g. `sw_info_0`).
	 - Implement receive path:
		 - Parse incoming messages as JSON into `LGTVResponse` structs.
		 - Call the associated callback or a default handler.
		 - Print responses to stdout as JSON, matching Python’s behavior as closely as reasonable.

Deliverables for Phase 2:
- Working WebSocket connection to the TV over `wss://` with handshake and echo tests.
- A small internal demo function that can call `swInfo` and print JSON to stdout.

---

### Phase 3 – Auth Flow (Pairing)

Goal: Port LGTVAuth so users can pair a new TV and store the client key from Swift.

1. Implement `LGTVAuthClient`
	 - Mirror Python’s LGTVAuth class:
		 - Connect to host/IP.
		 - Send `hello_data` without a client key.
		 - Handle `PROMPT` response → print "Please accept the pairing request on your LG TV".
		 - After user accepts, capture `client-key` from `registered` message.

2. MAC Address Discovery (Optional)
	 - Python uses `getmac` to infer MAC from IP.
	 - For Swift, implement one of:
		 - Shell out to `arp` / `ip neigh` equivalent on macOS and parse MAC.
		 - Or make MAC optional and only require IP/hostname.

3. Persist Auth Result
	 - Use `ConfigStore` to write a new/updated config entry for the TV, including client key and hostname/IP.
	 - Ensure repeated auth overwrites or merges gracefully.

Deliverables for Phase 3:
- `auth` subcommand wired into the CLI (see next phase) that guides user through pairing and writes config.

---

### Phase 4 – CLI Design (Swift ArgumentParser)

Goal: Recreate the Python `lgtv` CLI surface area in Swift using Swift ArgumentParser.

1. Main CLI Structure
	 - Create `LGTVControllerCLI` target main entry point:
		 - Use `ArgumentParser`’s `ParsableCommand`.
		 - Global options:
			 - `--name, -n <NAME>`: TV name, default to something like `LGC1`.
			 - `--ssl`: Boolean flag for wss vs ws.
	 - Subcommands:
		 - At minimum, implement the core set listed in TODO.md and LGWebOSRemote help, e.g.: `swInfo`, `getForegroundAppInfo`, `listApps`, `listInputs`, `setInput`, `volumeUp`, `volumeDown`, `setVolume`, `on`, `off`, etc.
		 - Include `scan` and `auth` similar to Python.

2. Command Dispatch
	 - Map each subcommand to a method on `LGTVWebOSClient`, mirroring Python’s LGTVRemote methods:
		 - Example: `volumeUp` → send `ssap://audio/volumeUp`.
	 - For commands with parameters, use ArgumentParser to capture arguments and pass them as typed values.
	 - Ensure that:
		 - Numeric args become Int/Double as in Python’s `parseargs` conversions.
		 - Boolean args accept `true`/`false` and map to Swift `Bool`.

3. Output Behavior
	 - For most commands, print the TV’s JSON response to stdout, similar to Python:
		 - On success: entire response JSON.
		 - On error: error response JSON.
	 - Make sure CLI exit codes are non‑zero on network/handshake failures.

4. Help Text Parity
	 - Ensure `lgtv --help` and `lgtv <command> --help` provide comparable information to the Python tool.
	 - Document any differences in a short section in this repo’s README or docs.

Deliverables for Phase 4:
- `swift run lgtv swInfo --name LGC1 --ssl` works and prints JSON like the Python tool.
- A subset of the Python commands ported and verified end‑to‑end.

---

### Phase 5 – Command Coverage & Parity

Goal: Implement the full set of commands from the Python CLI that are actually used in this repo / user workflows.

1. Inventory Commands
	 - From LGWebOSRemote’s LGTVRemote, list all methods that are exposed as commands.
	 - From the Python `lgtv` help (already in TODO.md), identify which commands are needed in practice.
	 - Consult this repo’s docs in `docs/DEVELOPMENT.md` and personal notes under `~/Documents/notes/lgtv/**/*` to prioritize.

2. Implement Remaining Commands
	 - For each command:
		 - Add a Swift method on `LGTVWebOSClient` with the same semantics.
		 - Add a matching CLI subcommand.
	 - Special handling:
		 - `openYoutubeId`, `openYoutubeURL`, `openYoutubeLegacyId`, `openYoutubeLegacyURL`: port the URL→ID parsing logic from Python.
		 - `serialise`: print the current config/connection info as JSON, matching Python’s behavior.

3. Testing & Verification
	 - For each high‑priority command, run side‑by‑side tests:
			- Python: `~/opt/lgtv/bin/lgtv --name LGC1 --ssl <command> ...`
			- Swift: `swift run lgtv <command> --name LGC1 --ssl ...`
	 - Compare outputs for shape and key fields.

Deliverables for Phase 5:
- Near‑parity command set between Swift CLI and Python CLI for real‑world usage.

---

### Phase 6 – Packaging & Developer Experience

1. Install/Run Story
	 - Provide `make` or simple shell script to:
		 - Build the Swift package via Swift Package Manager.
		 - Install the `lgtv` binary into `/opt/homebrew/bin` or another path under user control.
	 - Document how to switch between Python and Swift versions during transition.

2. VS Code / SwiftPM Integration
	 - Ensure the package can be opened and worked on comfortably in VS Code.
	- Optionally add VS Code tasks for `swift build`, `swift test`, and a convenient `swift run lgtv swInfo --name LGC1 --ssl` command.

3. Docs
	 - Update or add docs under `docs/` describing:
		 - How the Swift port relates to the Python original.
		 - Known behavior differences.
		 - How to pair a new TV and run common commands.

Deliverables for Phase 6:
- Repeatable build/install path.
- Minimal but clear docs for using the Swift CLI.

---

### Out‑of‑Scope / Future Phases

- Hammerspoon integration and macOS automation layer.
- Any UI beyond the CLI.
- Advanced error reporting or logging beyond what is needed for debugging parity with Python.

This plan should be executed in order by phases, verifying at each phase that at least one real command (e.g. `swInfo`) works end‑to‑end against the user’s LG C1 TV before moving on.

