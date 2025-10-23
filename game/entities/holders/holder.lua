require("functions.functional-programming")
local class = require("engine.object-v2")
local Box = require("engine.box")
-- ---@module "game.entities.card"
-- local Card = require("game.entities.card")
---@class HolderType
HolderType = {
	FOUNDATION = "foundation",
	TABLEAU = "tableau",
	STOCK = "stock",
	WASTE = "waste",
}

--- @class Holder
--- @field box Box
--- @field type string
--- @field cards Card[]
--- @field rank number | nil -- for ace type
--- @field suit number | nil -- for ace type
--- @field nextRank number
--- @field nextSuit number[]
local Holder = class.new("Holder")

---@param x number
---@param y number
---@param type string
function Holder:new(x, y, type)
	local holder = setmetatable({}, self)
	holder.box = Box:new(x, y, G.cardWidth, G.cardHeight)
	holder.cards = {}
	holder.type = type
	holder.nextRank = nil
	holder.nextSuit = {}
	return holder
end

---Sets the positions of each card in holder based on the holder's position
---This is how the game holders stack
function Holder:setPositions()
	for index, card in ipairs(self.cards) do
		if self.type == HolderType.TABLEAU then
			local yTransformMultiplier = G.gameHolderYStep * (index - 1)
			card:move(self.box.x, self.box.y + yTransformMultiplier)
			card.isInStack = index ~= #self.cards
			print("setting quad")
			card:setQuad()
		else
			card:move(self.box.x, self.box.y)
		end
	end
end

function Holder:displayLastCard()
	local card = self.cards[#self.cards]
	if card then
		card.isDisplayed = true
		card:setQuad()
	end
end

---@param card Card
function Holder:addCard(card)
	if self.cards == nil then
		self.cards = {}
	end
	table.insert(self.cards, card)
	card.parent = self
	self:setPositions()
end

---@param card Card
function Holder:removeCard(card)
	if card == nil then
		error("Tried to get index of card in holder, but the holder was nil! Wow, how could you do something so dumb!")
	end
	local index = self:getIndexOfCard(card)
	if index then
		self.cards[index].parent = nil
		table.remove(self.cards, index)
		self:setPositions()
	else
		error("Card not found in holder?")
	end
end

function Holder:checkCanAdd(rank, suit)
	-- Only used in subclasses, otherwise returns false
	local _ = rank
	local _ = suit
	return false
end

---@param card Card
function Holder:getIndexOfCard(card)
	if card == nil then
		error("Tried to get index of card that doesn't exist, why on earth would you do that? Dummy")
	end
	for index, cardToCheck in ipairs(self.cards) do
		if card.rank == cardToCheck.rank and card.suit == cardToCheck.suit then
			return index
		end
	end
	return nil
end

--- Checks if a moving card is dropped within the holder
function Holder:checkInHolder(x, y)
	return self.box:checkInBox(x, y, self:getAddRange().maxY)
end

--- gets the box that determines if a user
--- dropped a card on the holder
function Holder:getAddRange()
	local lastCard = self.cards[#self.cards]
	if lastCard == nil then
		return {
			minX = self.box.x,
			maxX = self.box.x + self.box.width,
			minY = self.box.y,
			maxY = self.box.y + (self.box.height * 1.5),
		}
	else
		return {
			minX = self.box.x,
			maxX = self.box.x + self.box.width,
			minY = lastCard.box.y,
			maxY = lastCard.box.y + (lastCard.box.height * 1.5), -- user can place on the last card or just a little below it
		}
	end
end

function Holder:draw()
	if #self.cards == 0 then
		love.graphics.setColor(0.21, 0.30, 0.16)
		love.graphics.rectangle("fill", self.box.x, self.box.y, self.box.width, self.box.height)
		love.graphics.setColor(1, 1, 1)
	else
		forEach(self.cards, function(card)
			card:draw()
		end)
	end
end

function Holder:update(dt)
	local _ = dt
end

function Holder:debugPrint()
	print("--------")
	print("Holder debug print")
	print("Holder cards length: ", #self.cards)
	print("--------")
end

return Holder
