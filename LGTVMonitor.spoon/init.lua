
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

return obj
