--- @class Holder
--- @field x number
--- @field y number
--- @field width number
--- @field height number
--- @field lowestRank number | nil
--- @field lowestSuit number | nil
--- @field type string
--- @field cards Card[]
Holder = {}
Holder.__index = Holder

function Holder.new(x, y, type)
	local holder = setmetatable({}, Holder)
	holder.x = x
	holder.y = y
	holder.width = G.cardWidth
	holder.height = G.cardHeight
	holder.cards = {}
	holder.type = type

	return holder
end

function Holder:setCardLocation()
	local yStep = 0
	local xStep = 0
	if self.type == "game" then
		yStep = 20
	end
	if #self.cards == 0 then
		self.lowestSuit = nil
		self.lowestRank = nil
	end
	for index, card in ipairs(self.cards) do
		local currentXStep = (index - 1) * xStep
		local currentYStep = (index - 1) * yStep
		card.x = self.x + currentXStep
		card.y = self.y + currentYStep
		if index == #self.cards then
			card.isInStack = false
			self.lowestRank = card.rank
			self.lowestSuit = card.suit
		else
			card.isInStack = true
		end
	end
end

---@param card Card
function Holder:addCard(card)
	card.isMoving = false
	table.insert(self.cards, card)
	if self.type == "game" then
		card.y = (#self.cards * 20) + self.y
		card.x = self.x
	end
	self:setCardLocation()
end

function Holder:checkCanAdd(rank, suit)
	print("rank is")
	print(rank)
	if #self.cards == 0 and rank == 13 then
		return true
	end
	-- Hearts or diamonds
	local result = false
	if self.lowestSuit == 1 or self.lowestSuit == 2 then
		result = suit == 3 or suit == 4
	end
	if self.lowestSuit == 3 or self.lowestSuit == 4 then
		result = suit == 1 or suit == 2
	end
	if result == false then
		return false
	end
	-- If card is 1 lower than current rank
	if self.lowestRank - 1 == rank and rank > 1 then
		return true
	else
		return false
	end
end

function Holder:checkShouldReveal()
	local nextCard = self.cards[#self.cards]
	if #self.cards > 0 and self.type == "game" and nextCard.isDisplayed == false then
		nextCard.isDisplayed = true
		nextCard.isDragable = true
	end
end

function Holder:checkIsClicked(mouseX, mouseY)
	for index, card in ipairs(self.cards) do
		if card.isDragable == true then
			card:mousepressed(mouseX, mouseY)
			if card.isMoving == true then
				print("clicked card is")
				print(card.rank)
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
