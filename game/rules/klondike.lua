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
---@param targetHolder Holder
---@param startingHolder Holder
function Klondike:canMove(card, targetHolder, startingHolder)
	local result = false
	switch(targetHolder.type, {
		[HolderType.FOUNDATION] = function()
			if not startingHolder.type == HolderType.TABLEAU or startingHolder.type == HolderType.WASTE then
				result = false
				return
			end
		end,
		[HolderType.STOCK] = function()
			result = startingHolder.type == HolderType.WASTE and #startingHolder.cards == 0
		end,
		[HolderType.WASTE] = function()
			result = startingHolder.type == HolderType.STOCK and #startingHolder.cards > 0
		end,
		[HolderType.TABLEAU] = function()
			local lastCard = startingHolder.cards[#startingHolder.cards]
			local isRank = function(holderSuit, cardRank, lastCardRank)
				if not holderSuit then
					return cardRank == 13
				else
					return cardRank == lastCardRank - 1
				end
			end
			local isSuit = function(suit1, suit2)
				if suit1 == 1 or suit1 == 2 then
					return suit2 == 3 or suit2 == 4
				else
					return suit2 == 1 or suit2 == 2
				end
			end
			switch(startingHolder.type, {
				[HolderType.FOUNDATION] = function()
					result = false
				end,
				[HolderType.STOCK] = function()
					result = false
				end,
			}, {
				function()
					result = isRank(startingHolder.suit, card.rank, lastCard.rank) and isSuit(card.suit, lastCard.suit)
				end,
			})
		end,
	})
	return result
end

return Klondike
