---@class AceHolder: Holder
AceHolder = Holder:extend()
function AceHolder:checkCanAdd(rank, suit)
	if self.suit == nil then
		return rank == 1
	end
	if self.suit == suit then
		return rank == (self.rank + 1)
	end
	return false
end
function AceHolder:addCard(card)
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
