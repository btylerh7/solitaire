local class = require("endine.class")

local Screen = class.new("Screen")
function Screen:new()
	local screen = setmetatable({}, self)
	return screen
end
