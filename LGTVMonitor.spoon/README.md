

# Generating docs
```sh
hs -c "hs.doc.builder.genJSON(\"$(pwd)\")" 
```


```lua
-- https://github.com/Hammerspoon/hammerspoon/blob/master/SPOONS.md#how-do-i-create-a-spoon
-- 
-- https://www.hammerspoon.org/Spoons/
-- https://github.com/Hammerspoon/hammerspoon/blob/master/SPOONS.md#what-is-a-spoon
-- https://zzamboni.github.io/zzSpoons/Hammer.html

```



```lua
-- When a user calls hs.loadSpoon(), Hammerspoon will load and execute init.lua 
-- from the relevant Spoon.

-- You should generally not perform any work, map any hotkeys, start any timers/watchers/etc. 
-- in the main scope of your init.lua. Instead, it should simply prepare an object with methods to be used later, then return the object.

-- If the object you return has an :init() method, Hammerspoon will call it automatically 
-- (although users can override this behaviour, so be sure to document your :init() method).

-- In the :init() method, you should do any work that is necessary to prepare resources for later use, 
-- although generally you should not be starting any timers/watchers/etc. or mapping any hotkeys here.

```
