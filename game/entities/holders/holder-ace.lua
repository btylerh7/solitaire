local class = require("engine.object-v2")
local Holder = require("game.entities.holders.holder")
---@class Foundation: Holder
local Foundation = class.inherit(Holder, "Foundation")

---@rturn Foundation
function Foundation:new(x, y)
	local type = HolderType.FOUNDATION
	local holder = Holder.new(self, x, y, type)
	return holder
end

function Foundation:checkCanAdd(rank, suit)
	if self.suit == nil then
		return rank == 1
	end
	if self.suit == suit then
		return rank == (self.rank + 1)
	end
	return false
end
function Foundation:addCard(card)
	if self.cards == nil then
		self.cards = {}
	end
	if self.suit == nil then
		self.suit = card.suit
	end
	self.rank = card.rank
	table.insert(self.cards, card)
	card.parent = self
	self:setPositions()
	States.gameState:checkIsWin()
end

return Foundation
