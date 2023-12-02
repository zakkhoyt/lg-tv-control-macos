local debug = true -- If you run into issues, set to true to enable debug messages
local autoReloadConfig = true -- If true, adds a watcher to reload hammerspoon config file on file update.

-- ------------------------------------ Logging
local LogLevel = { 
  info = "[INFO] ",
  debug = "[DEBUG] ",
  warning = "[WARNING] ",
  error = "[ERROR] "
}

function test_log_levels() 
  for key, value in pairs(LogLevel) do
    log(key, "Testing log level: "..(value or ""))
  end
  level = "unknown"
  log(level, "Testing log level: "..(level or ""))
end
 
--- :log()
--- Method
--- Start LGTVMonitor
---
--- Parameters:
---  * log_level - The level to log the message at. Results in each log being prefixed with string such as "[DEBUG] "
---  * message - The message to log
function log(log_level, message)  
  if debug then print((LogLevel[log_level] or "")..""..message) end
end

function log_d(message)
  if debug then print("[DEBUG] "..message) end
end

function log_w(message)
  if debug then print("[WARNING] "..message) end
end

function log_e(message)
  if debug then print("[ERROR] "..message) end
end


-- ------------------------------------ hs cli

function installHSCLI() 
  require("hs.ipc")
  -- https://www.hammerspoon.org/docs/hs.ipc.html#cliInstall
  if hs.ipc.cliUninstall() then
    log_d("hs.ipc.cliUninstall() == true")
  else 
    log_d("hs.ipc.cliUninstall() == false")
  end
  
  if hs.ipc.cliStatus() then
    log_d("hs.ipc.cliStatus() == true")
  else 
    log_d("hs.ipc.cliStatus() == false")
  end
  
  if hs.ipc.cliInstall() then
    log_d("hs.ipc.cliInstall() == true")
  else 
    log_d("hs.ipc.cliInstall() == false")
  end
  
  if hs.ipc.cliStatus() then
    log_d("hs.ipc.cliStatus() == true")
  else 
    log_d("hs.ipc.cliStatus() == false")
  end
end

-- ------------------------------------ Config watcher

function installConfigPathWatcher()
  -- Reloads hammerspoon's config file when directory contents change
  log_d("~~~~ Starting hs.pathwatcher for reloading config when ~/.hammerspoon is touched.")
  local myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", hs.reload):start()
end


-- ------------------------------------ main


log_d("\n\n")
log_d("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

log_d("~~~~ Testing Log Levels")
test_log_levels()

log_d("~~~~ Installing `hs` command line tool")
installHSCLI()

if autoReloadConfig then
  installConfigPathWatcher()
end 

log_d("~~~~ Loading spoon: LGTVMonitor")
lgtvs = hs.loadSpoon("LGTVMonitor")
lgtvs.start()
-- lgtvs.stop()
