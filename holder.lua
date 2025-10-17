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

function Holder:setPositions()
	for index, card in ipairs(self.cards) do
		if self.type == HolderType.GAME then
			if card.isMoving then
				break
			end
			card.x = self.x
			card.y = self.y + (G.gameHolderYStep * (index - 1))
			card.isDisplayed = index == #self.cards
			card.isInStack = index ~= #self.cards
			card:setQuad()
		else
			card.x = self.x
			card.y = self.y
		end
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
function Holder:removeCard(index)
	self.cards[index].parent = nil
	table.remove(self.cards, index)
	self:setPositions()
end

function Holder:checkCanAdd(rank, suit)
	return false
end

---@param card Card
function Holder:getIndexOfCard(card)
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
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	else
		for index, card in ipairs(self.cards) do
			card:draw()
		end
	end
end
