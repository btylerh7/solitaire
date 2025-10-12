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
	card.isMoving = false
	card.parentHolder = self
	card.isDragable = false
	if self.suit == nil then
		self.suit = card.suit
	end
	self.rank = card.rank
	table.insert(self.cards, card)
	self:setCardLocation()
end
