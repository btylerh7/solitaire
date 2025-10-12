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

	return holder
end

function Holder:setCardLocation()
	for _, card in ipairs(self.cards) do
		card.x = self.x
		card.y = self.y
	end
end

---@param card Card
function Holder:addCard(card)
	card.isMoving = false
	card.parentHolder = self
	table.insert(self.cards, card)
	if self.type == HolderType.GAME then
		card.y = (#self.cards * 20) + self.y
		card.x = self.x
	end
	self:setCardLocation()
end

function Holder:hasCards()
	return #self.cards > 0
end
function Holder:lastCard()
	return self.cards[#self.cards]
end

function Holder:checkShouldReveal()
	local hasCards = self:hasCards()
	local isGameHolder = self.type == HolderType.GAME
	local lastCard = self:lastCard()

	if hasCards and isGameHolder and not lastCard.isDisplayed then
		lastCard.isDisplayed = true
		lastCard.isDragable = true
	end
end

function Holder:checkIsClicked(mouseX, mouseY)
	for _, card in ipairs(self.cards) do
		if card.isDragable == true then
			if card.isInStack == true then
				card:setMoving(mouseX, mouseY)
			else
				card:setMoving(mouseX, mouseY)
			end

			if card.isMoving == true then
				State:setMoving(self, card)
				return true
			end
		end
	end
	return false
end

---@param index number - index of card to be removed
function Holder:removeCard(index)
	local startingTotal = #self.cards
	table.remove(self.cards, index)
	if #self.cards == startingTotal then
		print("error, card not removed properly")
	end
	if #self.cards == 0 then
		return
	end
end

function Holder:load() end
function Holder:update(dt)
	for key, value in ipairs(self.cards) do
		value:update(dt)
	end
end

function Holder:draw()
	if not next(self.cards) then
		love.graphics.setColor(0.21, 0.30, 0.16)
		love.graphics.rectangle("fill", self.x, self.y, self.width * 2, self.height * 2)
		love.graphics.setColor(1, 1, 1)
	end
	for index, card in ipairs(self.cards) do
		card:draw()
	end
end

function Holder:getLowestY()
	if #self.cards == 0 then
		return { lowestY = self.y + self.height, lastCardY = self.y }
	end
	local lastCard = self.cards[#self.cards]
	local lowestY = lastCard.y + lastCard.height
	return { lowestY = lowestY, lastCardY = lastCard.y }
end

---@param mouseX number
---@param mouseY number
---@return boolean
function Holder:isInHolder(mouseX, mouseY)
	local lowest = self:getLowestY()
	local minX = self.x
	local maxX = self.x + (self.width * G.zoomMultiplier)

	local isInX = mouseX > minX and mouseX < maxX
	local isInY = mouseY > lowest.lastCardY and mouseY < lowest.lowestY

	return isInX == true and isInY == true
end
