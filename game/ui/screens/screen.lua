local class = require("endine.class")

---@class Screen
---@field isLoaded boolean
local Screen = class.new("Screen")
function Screen:new()
	local screen = setmetatable({}, self)
	self.isLoaded = false
	return screen
end

return Screen
