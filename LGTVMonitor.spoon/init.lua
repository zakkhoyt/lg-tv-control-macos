
--- === LGTVMonitor ===
---
--- Helps an LGTV behave like a computer monitor (TODO)
---
--- Download (TODO): [https://github.com/zakkhoyt/lg-tv-control-macos)


local obj = {}
obj.__index = obj

-- Metadata
obj.name = "LGTV Monitor"
obj.version = "1.0"
obj.author = "Zakk Hoyt <vaporwarewolf@gmail.com>"
obj.license = "MIT - https://opensource.org/licenses/MIT"
obj.homepage = "https://github.com/zakkhoyt/lg-tv-control-macos"



--- ReloadConfiguration.watch_paths
--- Variable
--- List of directories to watch for changes, defaults to hs.configdir
-- obj.watch_paths = { hs.configdir }

-- -- TODO: [ ] Restore values before merging 
-- obj.tv_input = "HDMI_4" -- Input to which your Mac is connected
-- obj.switch_input_on_wake = true -- Switch input to Mac when waking the TV
-- obj.prevent_sleep_when_using_other_input = true -- Prevent sleep when TV is set to other input (ie: you're watching Netflix and your Mac goes to sleep)
-- obj.debug = true -- If you run into issues, set to true to enable debug messages
-- obj.disable_lgtv = false
-- -- NOTE: You can disable this script by setting the above variable to true, or by creating a file named
-- -- `disable_lgtv` in the same directory as this file, or at ~/.disable_lgtv.

-- -- You likely will not need to change anything below this line
-- obj.tv_name = "LGC1" -- Name of your TV, set when you run `lgtv auth`
-- obj.connected_tv_identifiers = {"LG TV", "LG TV SSCR2"} -- Used to identify the TV when it's connected to this computer
-- obj.screen_off_command = "off" -- use "screenOff" to keep the TV on, but turn off the screen.

-- -- TODO: [ ] Figure out how this ended up under homebrew instead of python. Can we be smart about this?
-- obj.lgtv_path = "~/opt/lgtv/bin/lgtv" -- Full path to lgtv executable (single user python install)
-- -- obj.lgtv_path = "/opt/lgtv/bin/lgtv" -- Full path to lgtv executable (all users python install)
-- -- obj.lgtv_path = "/opt/homebrew/bin/lgtv" -- Full path to lgtv executable (all users homebrew install)


-- -- TODO: [ ] Old vs new command builder
-- -- obj.lgtv_cmd = lgtv_path.." "..tv_name
-- obj.lgtv_cmd = lgtv_path.." --name "..tv_name
-- obj.app_id = "com.webos.app."..tv_input:lower():gsub("_", "")
-- obj.lgtv_ssl = true -- Required for firmware 03.30.16 and up. Also requires LGWebOSRemote version 2023-01-27 or newer.
-- obj.mute_status = false -- caches our muted state
-- -- A look up table from keyboard key to LGTV volume command
-- obj.keys_to_commands = {
--   ['SOUND_UP']="volumeUp", 
--   ['SOUND_DOWN']="volumeDown",
--   ['MUTE']="mute true",
--   ['UNMUTE']="mute false"
-- }

-- ********************** Public interface 

--- LGTVMonitor:init()
--- Method
--- Start LGTVMonitor
---
--- Parameters:
---  * None
function obj:init()
    print("LGTVMonitor obj:init() called")
    return self
end


--- LGTVMonitor:start()
--- Method
--- Start LGTVMonitor
---
--- Parameters:
---  * None
function obj:start()
    print("LGTVMonitor obj:start() called")
    bootstrap()
    return self
end

--- LGTVMonitor:stop()
--- Method
--- Stop LGTVMonitor
---
--- Parameters:
---  * None
function obj:stop()
    print("LGTVMonitor obj:stop() called")
    return self
end

--- LGTVMonitor:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for LGTVMonitor
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details for the following items:
---  * LGTVMonitor - This will cause the configuration to be reloaded
function obj:bindHotkeys(mapping)
    print("LGTVMonitor obj:bindHotkeys() called")
end

-- ********************** Private interface 


-- ********************** End

return obj
