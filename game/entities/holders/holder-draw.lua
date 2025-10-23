local class = require("engine.object-v2")
local Holder = require("game.entities.holders.holder")

---@class Stock:Holder
local Stock = class.inherit(Holder, "Stock")

---@return Stock
function Stock:new(x, y)
	local type = HolderType.STOCK
	local holder = Holder.new(self, x, y, type)
	return holder
end

return Stock
