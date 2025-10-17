---@class GameHolder: Holder
---@field lowestRank number | nil
---@field lowestSuit number | nil
GameHolder = Holder:extend()

---Sets the positions of each card in holder based on the holder's position
---This is how the game holders stack
function GameHolder:setPositions()
	local yStep = G.gameHolderYStep
	if #self.cards == 0 then
		self.lowestSuit = nil
		self.lowestRank = nil
	end
	for index, card in ipairs(self.cards) do
		local currentYStep = (index - 1) * yStep
		card.x = self.x
		card.y = self.y + currentYStep
		if index == #self.cards then
			card.isInStack = false
			self.lowestRank = card.rank
			self.lowestSuit = card.suit
		else
			card.isInStack = true
		end
	end
end

---Used when a card is dropped over a holder to see if it can be added
function GameHolder:checkCanAdd(rank, suit)
	-- Kings can be inserted if holder is empty
	if #self.cards == 0 and rank == 13 then
		return true
	end
	local isOppositeSuit = false

	-- Hearts or diamonds
	if self.lowestSuit == 1 or self.lowestSuit == 2 then
		isOppositeSuit = suit == 3 or suit == 4
	end
	if self.lowestSuit == 3 or self.lowestSuit == 4 then
		isOppositeSuit = suit == 1 or suit == 2
	end
	if isOppositeSuit == false then
		return false
	end
	-- If card is 1 lower than current rank
	if self.lowestRank - 1 == rank and rank > 1 then
		return true
	else
		return false
	end
end
