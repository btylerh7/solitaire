local class = require("engine.object-v2")
local Holder = require("game.entities.holders.holder")

---@class DrawHolder:Holder
local DrawHolder = class.inherit(Holder, "DrawHolder")

---@return DrawHolder
function DrawHolder:new(x, y, type)
	local holder = Holder.new(self, x, y, type)
	return holder
end

return DrawHolder
