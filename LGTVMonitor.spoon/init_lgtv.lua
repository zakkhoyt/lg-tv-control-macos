
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

-- TODO: [ ] Restore values before merging 
obj.tv_input = "HDMI_4" -- Input to which your Mac is connected
obj.switch_input_on_wake = true -- Switch input to Mac when waking the TV
obj.prevent_sleep_when_using_other_input = true -- Prevent sleep when TV is set to other input (ie: you're watching Netflix and your Mac goes to sleep)
obj.debug = true -- If you run into issues, set to true to enable debug messages
obj.disable_lgtv = false
-- NOTE: You can disable this script by setting the above variable to true, or by creating a file named
-- `disable_lgtv` in the same directory as this file, or at ~/.disable_lgtv.

-- You likely will not need to change anything below this line
obj.tv_name = "LGC1" -- Name of your TV, set when you run `lgtv auth`
obj.connected_tv_identifiers = {"LG TV", "LG TV SSCR2"} -- Used to identify the TV when it's connected to this computer
obj.screen_off_command = "off" -- use "screenOff" to keep the TV on, but turn off the screen.

-- TODO: [ ] Figure out how this ended up under homebrew instead of python. Can we be smart about this?
obj.lgtv_path = "~/opt/lgtv/bin/lgtv" -- Full path to lgtv executable (single user python install)
-- obj.lgtv_path = "/opt/lgtv/bin/lgtv" -- Full path to lgtv executable (all users python install)
-- obj.lgtv_path = "/opt/homebrew/bin/lgtv" -- Full path to lgtv executable (all users homebrew install)


-- TODO: [ ] Old vs new command builder
-- obj.lgtv_cmd = lgtv_path.." "..tv_name
obj.lgtv_cmd = lgtv_path.." --name "..tv_name
obj.app_id = "com.webos.app."..tv_input:lower():gsub("_", "")
obj.lgtv_ssl = true -- Required for firmware 03.30.16 and up. Also requires LGWebOSRemote version 2023-01-27 or newer.
obj.mute_status = false -- caches our muted state
-- A look up table from keyboard key to LGTV volume command
obj.keys_to_commands = {
  ['SOUND_UP']="volumeUp", 
  ['SOUND_DOWN']="volumeDown",
  ['MUTE']="mute true",
  ['UNMUTE']="mute false"
}

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

-- A convenience function for printing debug messages. 
function obj:log_d(message)
  if debug then print(message) end
end

function obj:lgtv_current_app_id()
  local foreground_app_info = exec_command("getForegroundAppInfo")
  for w in foreground_app_info:gmatch('%b{}') do
    if w:match('\"response\"') then
      local match = w:match('\"appId\"%s*:%s*\"([^\"]+)\"')
      if match then
        return match
      end
    end
  end
end

function obj:tv_is_connected()
  log_d("tv_is_connected() will list connected TVs...")
  for i, v in ipairs(connected_tv_identifiers) do
    log_d("  inspecting: "..v..".")
    if hs.screen.find(v) ~= nil then
      log_d("  "..v.." is connected.")
      return true
    else 

    end
  end

  log_d("No screens are connected")
  return false
end

function obj:tv_is_current_audio_device()
  local current_audio_device = hs.audiodevice.current().name
  log_d("Iterating connected audio devices to look for '"..current_audio_device.."' (current_audio_device)")
  for i, v in ipairs(connected_tv_identifiers) do
    log_d("  inspecting: "..v..".")
    if current_audio_device == v then
      -- [ ] Dont' print this every time the function is called
      log_d("   "..v.." is the current audio device (["..tostring(i).."])")
      return true
    else 
      log_d("   "..v.." is the NOT current audio device (["..tostring(i).."]). Inspecting next...")
    end
  end

  log_d(" "..current_audio_device.." could not be found in list. ")
  return false
end

function obj:dump_table(o)
  if type(o) == 'table' then
    local s = '{ '
    for k,v in pairs(o) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '['..k..'] = ' .. dump_table(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

function obj:exec_command(command)
  if lgtv_ssl then
    space_loc = command:find(" ")

    -- TODO: [ ] command builder
    -- --- "ssl" must be the first argument for commands like 'startApp'. Advance it to the expected position.
    -- if space_loc then  
    --   command = command:sub(1,space_loc).."ssl "..command:sub(space_loc+1)
    -- else
    --   command = command.." ssl"
    -- end
    command = "--ssl "..command
  end

  command = lgtv_cmd.." "..command
  log_d("Executing command: "..command)

  response = hs.execute(command)
  log_d(response)

  return response
end

-- Source: https://stackoverflow.com/a/4991602
function obj:file_exists(name)
  local f=io.open(name,"r")
  if f~=nil then
    io.close(f)
    return true
  else
    return false
  end
end

function obj:lgtv_disabled()
  return disable_lgtv or file_exists("./disable_lgtv") or file_exists(os.getenv('HOME') .. "/.disable_lgtv")
end

-- Converts an event_type (int) into a debug friendly description (string).
-- Source (look for `add_event_enum(lua_State* L)`): https://github.com/Hammerspoon/hammerspoon/blob/master/extensions/caffeinate/libcaffeinate_watcher.m
function obj:event_type_description(event_type)
  if event_type == hs.caffeinate.watcher.systemDidWake then
    return "systemDidWake"
  elseif event_type == hs.caffeinate.watcher.systemWillSleep then
    return "systemWillSleep"
  elseif event_type == hs.caffeinate.watcher.systemWillPowerOff then
    return "systemWillPowerOff"
  elseif event_type == hs.caffeinate.watcher.screensDidSleep then
    return "screensDidSleep"
  elseif event_type == hs.caffeinate.watcher.screensDidWake then
    return "screensDidWake"
  elseif event_type == hs.caffeinate.watcher.sessionDidResignActive then
    return "sessionDidResignActive"
  elseif event_type == hs.caffeinate.watcher.sessionDidBecomeActive then
    return "sessionDidBecomeActive"
  elseif event_type == hs.caffeinate.watcher.screensaverDidStart then
    return "screensaverDidStart"
  elseif event_type == hs.caffeinate.watcher.screensaverWillStop then
    return "screensaverWillStop"
  elseif event_type == hs.caffeinate.watcher.screensaverDidStop then
    return "screensaverDidStop"
  elseif event_type == hs.caffeinate.watcher.screensDidLock then
    return "screensDidLock"
  elseif event_type == hs.caffeinate.watcher.screensDidUnlock then
    return "screensDidUnlock"
  else
    return "unknown"
  end
end

func obj:bootstrap()
  if debug then
    log_d("TV name: "..tv_name)
    log_d("TV input: "..tv_input)
    log_d("LGTV path: "..lgtv_path)
    log_d("LGTV command: "..lgtv_cmd)
    log_d("SSL: "..tostring(lgtv_ssl))
    log_d("App ID: "..app_id)
    log_d("lgtv_disabled: "..tostring(lgtv_disabled()))
    if not lgtv_disabled() then
      exec_command("swInfo")
      exec_command("getForegroundAppInfo")
      log_d("Connected screens: "..dump_table(hs.screen.allScreens()))
      log_d("TV is connected? "..tostring(tv_is_connected()))
    end

    -- Reloads hammerspoon's config file when directory contents change
    log_d("*** *** Loading hs.pathwatcher")
    local myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", hs.reload):start()
  end

  -- TODO: [ ] rename watcher
  -- Watch for display and system sleep/wake/power events
  -- https://www.hammerspoon.org/docs/hs.caffeinate.watcher.html
  watcher = hs.caffeinate.watcher.new(
    function(event_type)
      event_name = event_type_description(event_type)
      log_d("---- ---- ---- ---- ---- ---- ---- ---- ")
      log_d("Watcher event: "..(event_type or "").." "..(event_name))

      if lgtv_disabled() then
        log_d("LGTV feature disabled. Skipping.")
        return
      end

      if (event_type == hs.caffeinate.watcher.screensDidWake or
          event_type == hs.caffeinate.watcher.systemDidWake or
          event_type == hs.caffeinate.watcher.screensDidUnlock) then

        if not tv_is_connected() then
          log_d("TV was not turned on because it is not connected")
          return
        end
        
        if screen_off_command == 'screenOff' then
          exec_command("screenOn") -- turn on screen
        else
          exec_command("on") -- wake on lan
        end
        log_d("TV was turned on")

        if lgtv_current_app_id() ~= app_id and switch_input_on_wake then
          exec_command("startApp "..app_id)
          log_d("TV input switched to "..app_id)
        end
      end

      if (event_type == hs.caffeinate.watcher.screensDidSleep or 
          event_type == hs.caffeinate.watcher.systemWillPowerOff or 
          event_type == hs.caffeinate.watcher.systemWillSleep) then

        if not tv_is_connected() then
          log_d("TV was not turned off because it is not connected")
          return
        end

        -- current_app_id returns empty string on some events like screensDidSleep
        current_app_id = lgtv_current_app_id()
        if current_app_id ~= app_id and prevent_sleep_when_using_other_input then
          log_d("TV is currently on another input ("..(current_app_id or "?").."). Skipping powering off.")
          return
        else
          exec_command(screen_off_command)
          log_d("TV screen was turned off with command `"..screen_off_command.."`.")
        end
      else 
        log_d("Event ignored")
      end
    end
  )

  -- TODO: [ ] Send bigger volume changes with modified keys (EX: cmd+volumeUp)
  -- TODO:     We might cache the volume level to help accomplish this. 
  -- TODO: [ ] Read system volume/mute, sync with TV (not sure if hammerspoon provides a way to read that)


  -- TODO: [ ] rename tap

  -- Listen for key press events. Specifically volumeUp, volumeDown, and mute keys. 
  tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown, hs.eventtap.event.types.systemDefined }, function(event)
    local event_type = event:getType()
    local system_key = event:systemKey()  
    local pressed_key = system_key.key


    -- reject key press events that we aren't interested in. 
    if event_type ~= hs.eventtap.event.types.systemDefined then
      log_d("-- keypress event is not of interest. Ignoring.")
      return
    end
    if not tv_is_current_audio_device() then
      log_d("-- keypress event but !tv_is_current_audio_device. Ignoring.")
      return
    end

    if system_key.down and (keys_to_commands[pressed_key] ~= nil) then
      -- If key is MUTE, decipher if we need to send unmute or mute command
      if pressed_key == 'MUTE' then
        -- toggle mute_status, possibly modify pressed_key
        mute_status = not mute_status
        if not mute_status then 
          -- UNMUTE isn't a real key, but serves to look up the correct command
          pressed_key = 'UNMUTE'
        end
      end

      log_d("**** **** **** **** **** **** **** **** ")
      log_d("Begin keypress event")
      log_d("-- keys_to_commands['"..tostring(pressed_key).."'] == "..tostring(keys_to_commands[pressed_key])..".")
      exec_command(keys_to_commands[pressed_key])
      log_d("End keypress event")
    end
  end)

  watcher:start()

  if not disable_audio_control then
    -- Query the TV's mute status and store so that we don't need to
    -- execute a query on each mute key press.
    local audio_status = hs.json.decode(exec_command("audioStatus"):gmatch('%b{}')())
    mute_status = audio_status["payload"]["mute"]
    log_d("Initial mute_status: "..(tostring(mute_status) or "<nil>").."")
  
    -- Start listening for keypress events. 
    tap:start()
  end





  -- TODO: [ ] pull main and see of the keyboard watcher stops responding on monitor change events. 


  -- This is a timer object used for non-blocking sleep functionality below. 
  local screen_watcher_timer = hs.timer.doAfter(
    0, 
    function()
      -- this is a dummy function so that we have a timer type variable
    end
  )

  -- TODO: [ ] For what ever reason, `.new()` does not function like we want. But newWithActiveScreen has a lot more callbacks. Happy medium?
  -- screen_watcher = hs.screen.watcher.new(
  -- Watch for monitor change events (add/remove monitors). 
  -- When this happens we need to re-start the keyboard watcher (tap) 
  -- which stops responding on monitor events (in my experience).
  screen_watcher = hs.screen.watcher.newWithActiveScreen(
    -- `active_screen_did_change` indicates if the change was due to a screen layout change (nil) or because the active screen changed (true).
    -- https://www.hammerspoon.org/docs/hs.screen.watcher.html
    function(active_screen_did_change)
      log_d("^^^^ ^^^^ ^^^^ ^^^^ ^^^^ ^^^^ ^^^^ ^^^^ ")
      log_d("Begin screen_watcher event")

      if tv_is_current_audio_device() then
        log_d("^^ tv_is_current_audio_device() is true")


        log_d("^^ Will restart tap")
        tap:stop()

        -- 0.5 seems to be the cutoff with my setup. Bump up to 1 sec. 
        local delay = 1
        
        -- log_d("^^   screen_watcher_timer.nextTrigger: "..tostring(screen_watcher_timer:nextTrigger())..".")
        if screen_watcher_timer:running() == true then
          log_d("^^   Cancelling wait to start a new wait.")
          screen_watcher_timer:stop() -- stop any existing timer
        -- else 
        --   log_d("^^   screen_watcher_timer.running == false")
        end
        
        log_d("^^ Waiting. Will call tap:start() after "..tostring(delay).." sec")
        screen_watcher_timer = hs.timer.doAfter(
          delay, 
          function()
            tap:start()
            log_d("^^ Did restart tap")
          end
        )
      else
        log_d("^^ tv_is_current_audio_device() is false")
      end

      log_d("End screen_watcher event")
    end
  )

  log_d("Will start screen_watcher")
  screen_watcher:start()
  log_d("Did start screen_watcher")

  -- TODO: [ ] Can we catch when accessiblilty is not enabled (new hammerspoon setup)
end

-- ********************** End

return obj
