require("functions.switch")
local Rule = require("game.rules.rule")
local class = require("engine.object-v2")
local GameHolder = require("game.entities.holders.holder-game")
local AceHolder = require("game.entities.holders.holder-ace")
local DrawHolder = require("game.entities.holders.holder-draw")

---@class Klondike:Rule
local Klondike = class.inherit(Rule, "Klondike")

---@return Klondike
function Klondike:new()
	local rule = Rule:new({
		tableauColumns = 7,
		foundationColumns = 4,
		wasteColumns = 1,
		useStock = true,
	})
	setmetatable(rule, self)
	self.__index = self
	return rule
end

-----@return {foundation: AceHolder[], tableau: GameHolder[], stock: DrawHolder, waste: DrawHolder[]}
function Klondike:deal()
	local steppedX = function(startingValue, index)
		return startingValue + (LocationConfig.stepCount * (index - 1))
	end

	local startX = LocationConfig.leftSideX
	local startY = LocationConfig.topRowY

	local stock = DrawHolder:new(steppedX(startX, 1), startY, "draw")
	local waste = {}
	table.insert(waste, DrawHolder:new(steppedX(startX, 2), startY, "drawn"))

	startX = LocationConfig.aceAreaX
	startY = LocationConfig.topRowY
	local foundation = {
		AceHolder:new(steppedX(startX, 1), startY, "ace"),
		AceHolder:new(steppedX(startX, 2), startY, "ace"),
		AceHolder:new(steppedX(startX, 3), startY, "ace"),
		AceHolder:new(steppedX(startX, 4), startY, "ace"),
	}
	startX = LocationConfig.leftSideX
	startY = LocationConfig.cardRowY

	local tableau = {
		GameHolder:new(steppedX(startX, 1), startY, "game"),
		GameHolder:new(steppedX(startX, 2), startY, "game"),
		GameHolder:new(steppedX(startX, 3), startY, "game"),
		GameHolder:new(steppedX(startX, 4), startY, "game"),
		GameHolder:new(steppedX(startX, 5), startY, "game"),
		GameHolder:new(steppedX(startX, 6), startY, "game"),
		GameHolder:new(steppedX(startX, 7), startY, "game"),
	}
	local cardIndex = 1
	local lastCardIndex = #States.gameState.activeCards
	local addToHolder = function(index, holder, column, row)
		local card = States.gameState.activeCards[index]
		card.parent = holder
		card.isInStack = column ~= row

		--If card is last in holder, display it
		card.isDisplayed = column == row
		card:setQuad()
		holder:addCard(card)
	end
	for column, holder in ipairs(tableau) do
		-- each column has number of rows based on its index. First column has one row. Second column has two rows, etc.
		for row = 1, column, 1 do
			addToHolder(cardIndex, holder, column, row)
			cardIndex = cardIndex + 1
		end
	end
	-- Add rest to stock
	for i = cardIndex, lastCardIndex, 1 do
		local card = States.gameState.activeCards[i]
		card.parent = stock
		card.isDisplayed = false
		card.isInStack = false
		stock:addCard(card)
	end

	local result = {
		tableau = tableau,
		foundation = foundation,
		stock = stock,
		waste = waste,
	}
	return result
end

---@param card Card
---@param target Holder
---@param start Holder
---If trying to add a card to foundation pile, make sure it is allowed
function Klondike:foundationCheck(card, target, start)
	if start.type == HolderType.STOCK or start.type == HolderType.FOUNDATION then
		return false
	end
	if #target.cards == 0 then
		return card.rank == 1
	end
	return card.rank == target.rank + 1
end

---@param card Card
---@param targetHolder Holder
---@param startingHolder Holder
function Klondike:canMove(card, targetHolder, startingHolder)
	local result = false
	switch(targetHolder.type, {
		[HolderType.FOUNDATION] = function() end,
		[HolderType.TABLEAU] = function()
			local parentHolderCondition = startingHolder.type == HolderType.WASTE
				or startingHolder.type == HolderType.TABLEAU
			if #targetHolder.cards == 0 then
				local isEmpty = #targetHolder.cards == 0
				result = card.rank == 13
			else
				local lastCard = targetHolder.cards[#targetHolder.cards]
				return parentHolderCondition
					and self:isOneLess(card.rank, lastCard.rank)
					and self:isOppositeSuit(card.suit, lastCard.suit)
			end
		end,
		[HolderType.STOCK] = function()
			result = startingHolder.type == HolderType.WASTE and #targetHolder.cards == 0
		end,
		[HolderType.WASTE] = function()
			result = startingHolder.type == HolderType.STOCK
		end,
	})
	return result
end

return Klondike
