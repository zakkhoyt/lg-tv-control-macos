
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



-- Point = {x = 0, y = 0}
-- Point.__index = Point

-- function Point:create(o)
--   o.parent = self
--   return o
-- end

-- function Point:move(p)
--   -- self.x = self.x + p.x
--   -- self.y = (self.y or 0) + (p.y or 0)
-- end

-- -- function Point:print(name)
-- --   print("Point: "..name)
-- --   print("Point.x: "..self.x)
-- --   print("Point.y: "..self.y)
-- --   print("Point.version: "..self.version)
-- -- end

-- function Point:print(point, name)
--   print("Point: "..name)
--   print("Point.x: "..point.x)
--   print("Point.y: "..(point.y or "-"))
-- end

-- All about classes, scope, static, instance, inheritance:
-- https://paulwatt526.github.io/wattageTileEngineDocs/luaOopPrimer.html#public-functions
local Point = {}
Point.new = function(x, y)
  -- private vars
  local self = {}
  local _x = 1

  -- private functions
  local function _print()
    print("self.x: "..self.x)
    print("self.y: "..self.y)
    print("_x: "..(_x or "n/a"))
  end

  -- public  vars
  self.x = (x or 0)
  self.y = (y or 0)
  
  -- public functions
  function self.move(x, y)
    _x = self.x
    self.x = x
    self.y = y
  end
  
  function self.print()
    _print()
  end
  
  return self
end

function Point:numberOfValue()
  print("A point has 2 values")
end

function Point.someStatic()
  print("static A point has 2 values")
end

-- ********************** Public interface 

--- LGTVMonitor:init()
--- Method
--- Start LGTVMonitor
---
--- Parameters:
---  * None
function obj:init()
  print("LGTVMonitor obj:init() called")

  --
  -- creating points
  --
  -- p1 = Point:create{x = 10, y = 20}
  -- Point:print(p1, "p1")
  
  -- p2 = Point:create{x = 10}  -- y will be inherited until it is set
  -- Point:print(p2, "p2")
  
  -- --
  -- -- example of a method invocation
  -- --
  -- p1:move(p2)
  -- Point:print(p1, "p1")

  -- instantiate
  local p1 = Point.new(2, 3)

  -- instance methods
  p1.move(10, 20)
  p1.print()

  -- static functions
  Point.numberOfValue()
  Point.someStatic()
  Point:numberOfValue()
  Point:someStatic()

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
    -- bootstrap()
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
