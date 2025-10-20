require("functions.functional-programming")
---@class HolderType
HolderType = {
	ACE = "ace",
	GAME = "game",
	DRAW = "draw",
}

--- @class Holder:Base
--- @field x number
--- @field y number
--- @field width number
--- @field height number
--- @field type string
--- @field cards Card[]
--- @field rank number | nil -- for ace type
--- @field suit number | nil -- for ace type
--- @field nextRank number
--- @field nextSuit number[]
Holder = Base:extend()

---@param x number
---@param y number
---@param type string
function Holder:new(x, y, type)
	---@class Holder:Base
	local holder = setmetatable({}, self)
	holder.x = x
	holder.y = y
	holder.width = G.cardWidth
	holder.height = G.cardHeight
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
		if self.type == HolderType.GAME then
			card.x = self.x
			card.y = self.y + (G.gameHolderYStep * (index - 1))
			card.isInStack = index ~= #self.cards
			card:setQuad()
		else
			card.x = self.x
			card.y = self.y
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
	local addRange = self:getAddRange()
	return x > addRange.minX and x < addRange.maxX and y > addRange.minY and y < addRange.maxY
end

--- gets the box that determines if a user
--- dropped a card on the holder
function Holder:getAddRange()
	local lastCard = self.cards[#self.cards]
	if lastCard == nil then
		return {
			minX = self.x,
			maxX = self.x + self.width,
			minY = self.y,
			maxY = self.y + (self.height * 1.5),
		}
	else
		return {
			minX = self.x,
			maxX = self.x + self.width,
			minY = lastCard.y,
			maxY = lastCard.y + (lastCard.height * 1.5), -- user can place on the last card or just a little below it
		}
	end
end

function Holder:draw()
	if #self.cards == 0 then
		love.graphics.setColor(0.21, 0.30, 0.16)
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
		love.graphics.setColor(1, 1, 1)
	else
		for index, card in ipairs(self.cards) do
			card:draw()
		end
	end
end

function Holder:debugPrint()
	print("--------")
	print("Holder debug print")
	print("Holder cards length: ", #self.cards)
	print("--------")
end
