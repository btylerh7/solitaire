local Rule = require("game.rules.rule")
local class = require("engine.class")
local Tableau = require("game.entities.holders.holder-game")
local Foundation = require("game.entities.holders.holder-ace")
local Stock = require("game.entities.holders.holder-draw")
local Waste = require("game.entities.holders.holder-waste")

---@class Freecell:Rule
local Freecell = class.inherit(Rule, "Freecell")

---@return Freecell
function Freecell:new()
	local rule = Rule:new({
		tableauColumns = 8,
		foundationColumns = 4,
		wasteColumns = 4,
		useStock = false,
	})
	setmetatable(rule, self)
	self.__index = self
	return rule
end

function Freecell:deal()
	local steppedX = function(startingValue, index)
		return startingValue + (LocationConfig.stepCount * (index - 1))
	end

	local startX = LocationConfig.leftSideX
	local startY = LocationConfig.topRowY

	local foundation = {
		Foundation:new(steppedX(startX, 1), startY),
		Foundation:new(steppedX(startX, 2), startY),
		Foundation:new(steppedX(startX, 3), startY),
		Foundation:new(steppedX(startX, 4), startY),
	}

	startX = LocationConfig.aceAreaX
	startY = LocationConfig.topRowY

	local waste = {
		Waste:new(steppedX(startX, 1), startY),
		Waste:new(steppedX(startX, 2), startY),
		Waste:new(steppedX(startX, 3), startY),
		Waste:new(steppedX(startX, 4), startY),
	}

	local stock = {}

	startX = LocationConfig.leftSideX
	startY = LocationConfig.cardRowY

	local tableau = {
		Tableau:new(steppedX(startX, 1), startY),
		Tableau:new(steppedX(startX, 2), startY),
		Tableau:new(steppedX(startX, 3), startY),
		Tableau:new(steppedX(startX, 4), startY),
		Tableau:new(steppedX(startX, 5), startY),
		Tableau:new(steppedX(startX, 6), startY),
		Tableau:new(steppedX(startX, 7), startY),
		Tableau:new(steppedX(startX, 8), startY),
	}
	local cardIndex = 1
	local lastCardIndex = #States.gameState.activeCards
	local addToHolder = function(index, holder, column, row)
		local card = States.gameState.activeCards[index]
		card.parent = holder
		card.isInStack = column ~= row

		-- in freecell all tableau cards are displayed
		card.isDisplayed = true
		card:setQuad()
		holder:addCard(card)
	end
	-- Seven rows on first four cards in freecell
	-- Six rows on last four cards
	for row = 1, 7, 1 do
		for column = 1, #tableau, 1 do
			if row < 7 then
				addToHolder(cardIndex, tableau[column], column, row)
				cardIndex = cardIndex + 1
			end
			if row == 7 and column < 5 then
				addToHolder(cardIndex, tableau[column], column, row)
				cardIndex = cardIndex + 1
			end
		end
	end

	local result = {
		tableau = tableau,
		foundation = foundation,
		stock = stock,
		waste = waste,
	}
	return result
end
---@param cards Card[]
function Freecell:isInOrder(cards)
	local isInOrder = true
	local previousCard = nil
	forEach(cards, function(card)
		print(card.rank)
		print(card.suit)
		if previousCard == nil then
			previousCard = card
		elseif isInOrder then
			local oppositeSuit = self:isOppositeSuit(card.suit, previousCard.suit)
			print("isOppositeSuit", oppositeSuit)
			local isOneLess = self:isOneLess(card.rank, previousCard.rank)
			print("oneLess", isOneLess)
			isInOrder = oppositeSuit and isOneLess
			previousCard = card
		end
	end)
	return isInOrder
end
function Freecell:getFreeCellCount()
	local freeCellCount = 0
	forEach(HolderLocations.drawnPile, function(holder)
		if #holder.cards == 0 then
			freeCellCount = freeCellCount + 1
		end
	end)
	return freeCellCount
end
---@param card Card
---@param target Holder
---@param start Holder
---If trying to add a card to a tableau column, make sure it is allowed
function Freecell:tableauCheck(card, target, start)
	if start.type == HolderType.STOCK or start.type == HolderType.FOUNDATION then
		return false
	end

	if start.type == HolderType.TABLEAU and not self:isInOrder(States.gameState.movingCards.cards) then
		print("Not in order...")
		return false
	end

	local freeCellCount = self:getFreeCellCount()
	local movableCardAmount = freeCellCount + 1
	local emptyTableauCount = filter(HolderLocations.cardSlots, function(holder)
		return #holder.cards == 0
	end)
	if #emptyTableauCount > 0 and #target.cards > 0 then
		movableCardAmount = movableCardAmount * 2
	end

	local movableCardCheck = #States.gameState.movingCards.cards <= movableCardAmount

	if #target.cards == 0 then
		return movableCardCheck
	end
	if not self:isOppositeSuit(card.suit, target.cards[#target.cards].suit) then
		return false
	end
	return movableCardCheck and card.rank == target.rank - 1
end

---@param card Card
---@param target Holder
---@param start Holder
---If trying to add a card to foundation pile, make sure it is allowed
function Freecell:foundationCheck(card, target, start)
	-- TODO make sure only one ccard can be added at a time
	if start.type == HolderType.STOCK or start.type == HolderType.FOUNDATION then
		return false
	end
	if #target.cards == 0 then
		return card.rank == 1
	end
	return card.rank == target.rank + 1 and card.suit == target.suit
end

---@param card Card
---@param targetHolder Holder
---@param startingHolder Holder
function Freecell:canMove(card, targetHolder, startingHolder)
	-- reference https://solitaired.com/guides/how-to-play-freecell
	local result = false
	switch(targetHolder.type, {
		[HolderType.FOUNDATION] = function()
			result = self:foundationCheck(card, targetHolder, startingHolder)
		end,
		[HolderType.TABLEAU] = function()
			result = self:tableauCheck(card, targetHolder, startingHolder)
		end,
		[HolderType.STOCK] = function()
			result = false
		end,
		[HolderType.WASTE] = function()
			result = #targetHolder.cards == 0
		end,
	})
	return result
end

return Freecell
