local class = require("engine.object-v2")
local Holder = require("game.entities.holders.holder")
local DrawHolder = require("game.entities.holders.holder-draw")
local AceHolder = require("game.entities.holders.holder-ace")
local GameHolder = require("game.entities.holders.holder-game")
local Rules = require("game.rules.rules")
local Klondike = require("game.rules.klondike")
local Freecell = require("game.rules.freecell")
local inspect = require("vendor.inspect")
LocationConfig = {
	stepCount = 125,
	topRowY = 15,
	cardRowY = 250,
	-- leftSideX = 50,
	leftSideX = 25,
	aceAreaX = love.graphics.getWidth() / 2,
}

---@class HolderLocations
---@field cardSlots Tableau[]
---@field aceSlots Foundation[]
---@field drawPile Stock
---@field drawnPile Waste[]

local HolderLocations = class.new("HolderLocations")

function HolderLocations:setupBoard()
	assert(States.gameState.gameRules ~= nil, "Game Rules not set")
	local holders = States.gameState.gameRules:deal()
	assert(holders.waste ~= nil, "Waste pile must not be nil")
	print(#holders.waste, #holders.tableau)
	self.cardSlots = holders.tableau
	self.aceSlots = holders.foundation
	self.drawPile = holders.stock
	self.drawnPile = holders.waste
end

function HolderLocations:updateAll(dt)
	self.drawPile:update(dt)
	forEach(self.drawnPile, function(holder)
		holder:update(dt)
	end)
	forEach(self.cardSlots, function(holder)
		holder:update(dt)
	end)
	forEach(self.aceSlots, function(holder)
		holder:update(dt)
	end)
end
function HolderLocations:drawAll()
	if States.gameState.gameRules.useStock then
		self.drawPile:draw()
	end
	forEach(self.drawnPile, function(slot)
		slot:draw()
	end)
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
	local resultHolder = nil
	forEach(self.cardSlots, function(holder)
		if holder:checkInHolder(x, y) then
			print("in holder, game")
			resultHolder = holder
		end
	end)
	forEach(self.aceSlots, function(holder)
		if holder:checkInHolder(x, y) then
			print("in holder, ace")
			resultHolder = holder
		end
	end)
	forEach(self.drawnPile, function(holder)
		if holder:checkInHolder(x, y) then
			print("in waste pile")
			resultHolder = holder
		end
	end)
	if self.drawPile.checkInHolder and self.drawPile:checkInHolder(x, y) then
		print("in stock pile")
		resultHolder = self.drawPile
	end
	return resultHolder
end

---Used when draw pile is clicked to reveal extra card
function HolderLocations:drawCard()
	if type(States.gameState.gameRules) == Freecell then
		print("No card drawing in Freecell")
		return
	end
	if #self.drawPile.cards > 0 then
		--Draw card normally
		local drawPile = self.drawPile.cards
		local nextCard = drawPile[#drawPile]
		self.drawPile:removeCard(nextCard)
		nextCard.isDisplayed = true
		print("setting quad")
		nextCard:setQuad()
		self.drawnPile[1]:addCard(nextCard)
	elseif States.gameState.remainingRedraws > 0 then
		--Reset draw pile
		print("time to reset")
		while #self.drawnPile[1].cards > 0 do
			local currentCard = self.drawnPile[1].cards[#self.drawnPile[1].cards]
			currentCard.isDisplayed = false
			print("setting quad")
			currentCard:setQuad()
			self.drawPile:addCard(currentCard)
			self.drawnPile[1]:removeCard(currentCard)
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
