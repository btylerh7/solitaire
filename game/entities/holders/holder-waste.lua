local class = require("engine.object-v2")
local Holder = require("game.entities.holders.holder")

---@class Waste:Holder
local Waste = class.inherit(Holder, "Waste")

---@return Waste
function Waste:new(x, y)
	local type = HolderType.WASTE
	local holder = Holder.new(self, x, y, type)
	return holder
end

return Waste
