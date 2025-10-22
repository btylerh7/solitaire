local class = require("engine.object-v2")
local Holder = require("game.entities.holders.holder")
local DrawHolder = require("game.entities.holders.holder-draw")
local AceHolder = require("game.entities.holders.holder-ace")
local GameHolder = require("game.entities.holders.holder-game")
local Rules = require("game.rules.rules")
LocationConfig = {
	stepCount = 125,
	topRowY = 15,
	cardRowY = 250,
	leftSideX = 50,
	aceAreaX = love.graphics.getWidth() / 2,
}

---@class HolderLocations
---@field cardSlots Tableau[]
---@field aceSlots Foundation[]
---@field drawPile DrawHolder
---@field drawnPile DrawHolder

local HolderLocations = class.new("HolderLocations")

function HolderLocations:setupBoard()
	assert(States.gameState.gameRules ~= nil, "Game Rules not set")
	local holders = States.gameState.gameRules:deal()
	print(holders.foundation, holders.tableau)
	assert(holders.waste ~= nil, "Waste pile must not be nil")
	self.cardSlots = holders.tableau
	self.aceSlots = holders.foundation
	self.drawPile = holders.stock
	self.drawnPile = holders.waste[1]
end

function HolderLocations:setup()
	local steppedX = function(startingValue, index)
		return startingValue + (LocationConfig.stepCount * (index - 1))
	end

	local startX = LocationConfig.leftSideX
	local startY = LocationConfig.topRowY

	self.drawPile = DrawHolder:new(steppedX(startX, 1), startY, "draw")
	self.drawnPile = DrawHolder:new(steppedX(startX, 2), startY, "drawn")

	startX = LocationConfig.aceAreaX
	startY = LocationConfig.topRowY
	self.aceSlots = {
		AceHolder:new(steppedX(startX, 1), startY, "ace"),
		AceHolder:new(steppedX(startX, 2), startY, "ace"),
		AceHolder:new(steppedX(startX, 3), startY, "ace"),
		AceHolder:new(steppedX(startX, 4), startY, "ace"),
	}
	startX = LocationConfig.leftSideX
	startY = LocationConfig.cardRowY

	self.cardSlots = {
		GameHolder:new(steppedX(startX, 1), startY, "game"),
		GameHolder:new(steppedX(startX, 2), startY, "game"),
		GameHolder:new(steppedX(startX, 3), startY, "game"),
		GameHolder:new(steppedX(startX, 4), startY, "game"),
		GameHolder:new(steppedX(startX, 5), startY, "game"),
		GameHolder:new(steppedX(startX, 6), startY, "game"),
		GameHolder:new(steppedX(startX, 7), startY, "game"),
	}
end

--- Uses States.gameState.activeCards to place cards in correct spots
function HolderLocations:addShuffledCards()
	local cardsIndex = 1
	local lastCardIndex = #States.gameState.activeCards
	-- Once for each game holder
	for row = 1, 7, 1 do
		for column = 1, row, 1 do
			local card = States.gameState.activeCards[cardsIndex]
			local currentHolder = self.cardSlots[row]
			card.parent = currentHolder
			card.isInStack = column ~= row

			--If card is last in holder, display it
			card.isDisplayed = column == row
			card:setQuad()
			currentHolder:addCard(card)
			cardsIndex = cardsIndex + 1
		end
	end
	-- Add rest to draw pile
	for i = cardsIndex, lastCardIndex, 1 do
		local card = States.gameState.activeCards[i]
		local currentHolder = self.drawPile

		card.parent = currentHolder
		card.isDisplayed = false
		card.isInStack = false

		currentHolder:addCard(card)
	end
end

function HolderLocations:updateAll(dt)
	self.drawPile:update(dt)
	self.drawnPile:update(dt)
	for index, value in ipairs(self.cardSlots) do
		value:update(dt)
	end
	for index, value in ipairs(self.aceSlots) do
		value:update(dt)
	end
end
function HolderLocations:drawAll()
	self.drawPile:draw()
	self.drawnPile:draw()
	forEach(self.cardSlots, function(slot)
		slot:draw()
	end)
	forEach(self.aceSlots, function(slot)
		slot:draw()
	end)
end

---Used to determine if a point is inside any of the game's holders
---@param x number
---@param y number
---@return Holder|nil
function HolderLocations:findHolder(x, y)
	for _, holder in ipairs(self.cardSlots) do
		if holder:checkInHolder(x, y) then
			print("in holder, game")
			return holder
		end
	end
	for _, holder in ipairs(self.aceSlots) do
		if holder:checkInHolder(x, y) then
			print("in holder, ace")
			return holder
		end
	end
	return nil
end

---Used when draw pile is clicked to reveal extra card
function HolderLocations:drawCard()
	if #self.drawPile.cards > 0 then
		--Draw card normally
		local drawPile = self.drawPile.cards
		local nextCard = drawPile[#drawPile]
		self.drawPile:removeCard(nextCard)
		nextCard.isDisplayed = true
		print("setting quad")
		nextCard:setQuad()
		self.drawnPile:addCard(nextCard)
	elseif States.gameState.remainingRedraws > 0 then
		--Reset draw pile
		print("time to reset")
		while #self.drawnPile.cards > 0 do
			local currentCard = self.drawnPile.cards[#self.drawnPile.cards]
			currentCard.isDisplayed = false
			print("setting quad")
			currentCard:setQuad()
			self.drawPile:addCard(currentCard)
			self.drawnPile:removeCard(currentCard)
		end
		States.gameState.remainingRedraws = States.gameState.remainingRedraws - 1
	else
		--No more drawing, do nothing
		return
	end
end

function HolderLocations:getHolderType(x, y)
	local gameHolder = y > LocationConfig.cardRowY
	local aceHolder = not gameHolder and x > LocationConfig.aceAreaX
	local drawPileHolder = not aceHolder and x > LocationConfig.leftSideX
	if gameHolder then
		return HolderType.TABLEAU
	elseif aceHolder then
		return HolderType.FOUNDATION
	elseif drawPileHolder then
		return HolderType.STOCK
	else
		return nil
	end
end

return HolderLocations
