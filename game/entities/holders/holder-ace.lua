local class = require("engine.object-v2")
local Holder = require("game.entities.holders.holder")
---@class Tableau: Holder
local Tableau = class.inherit(Holder, "Tableau")

---@rturn Tableau
function Tableau:new(x, y, type)
	local holder = Holder.new(self, x, y, type)
	return holder
end

function Tableau:checkCanAdd(rank, suit)
	if self.suit == nil then
		return rank == 1
	end
	if self.suit == suit then
		return rank == (self.rank + 1)
	end
	return false
end
function Tableau:addCard(card)
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

return Tableau
