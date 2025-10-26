require("functions.switch")
local Rule = require("game.rules.rule")
local class = require("engine.object-v2")
local Tableau = require("game.entities.holders.holder-game")
local Foundation = require("game.entities.holders.holder-ace")
local Stock = require("game.entities.holders.holder-draw")
local Waste = require("game.entities.holders.holder-waste")

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

function Klondike:deal()
	local steppedX = function(startingValue, index)
		return startingValue + (LocationConfig.stepCount * (index - 1))
	end

	local startX = LocationConfig.leftSideX
	local startY = LocationConfig.topRowY

	local stock = Stock:new(steppedX(startX, 1), startY)
	local wastePile = {
		Waste:new(steppedX(startX, 2), startY),
	}

	startX = LocationConfig.aceAreaX
	startY = LocationConfig.topRowY
	local foundation = {
		Foundation:new(steppedX(startX, 1), startY),
		Foundation:new(steppedX(startX, 2), startY),
		Foundation:new(steppedX(startX, 3), startY),
		Foundation:new(steppedX(startX, 4), startY),
	}
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
		waste = wastePile,
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
	return card.rank == target.rank + 1 and card.suit == target.suit
end

---@param card Card
---@param target Holder
---@param start Holder
---If trying to add a card to a tableau column, make sure it is allowed
function Klondike:tableauCheck(card, target, start)
	if start.type == HolderType.STOCK or start.type == HolderType.FOUNDATION then
		return false
	end
	if #target.cards == 0 then
		return card.rank == 13
	end
	if not self:isOppositeSuit(card.suit, target.cards[#target.cards].suit) then
		return false
	end
	return card.rank == target.rank - 1
end

---@param card Card
---@param targetHolder Holder
---@param startingHolder Holder
function Klondike:canMove(card, targetHolder, startingHolder)
	local result = false
	switch(targetHolder.type, {
		[HolderType.FOUNDATION] = function()
			result = self:foundationCheck(card, targetHolder, startingHolder)
		end,
		[HolderType.TABLEAU] = function()
			result = self:tableauCheck(card, targetHolder, startingHolder)
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
