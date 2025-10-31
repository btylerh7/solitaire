local class = require("engine.object-v2")
local Box = require("engine.box")

---@class Gamer
---A gamer is an enemy solitaire player who will challenge you if interacted with.
---@field box Box
---@field isDefeated boolean
---@field chosenGame Rule
local Gamer = class.new("Gamer")

function Gamer:new(x, y)
	local gamer = setmetatable({}, self)
	gamer.box = Box:new(x, y, 32, 32)
end

return Gamer
