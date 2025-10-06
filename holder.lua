--- @class Holder
--- @field x number
--- @field y number
--- @field width number
--- @field height number
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
	if self.type == "drawn" then
		xStep = 20
	end
	for index, card in ipairs(self.cards) do
		local currentXStep = (index - 1) * xStep
		local currentYStep = (index - 1) * yStep
		card.x = self.x + currentXStep
		card.y = self.y + currentYStep
		if index == #self.cards then
			card.isInStack = false
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

---@param index number - index of card to be removed
function Holder:removeCard(index)
	local startingTotal = #self.cards
	table.remove(self.cards, index)
	if #self.cards == startingTotal then
		print("error, card not removed properly")
	end
	-- for index, currentCard in ipairs(self.cards) do
	-- 	if card.rank == currentCard.rank and card.suit == currentCard.suit then
	-- 		table.remove(self.cards, index)
	-- 		self:setCardLocation()
	-- 		return
	-- 	end
	-- end
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
	local lastCard = self.cards[#self.cards]
	local lowestY = lastCard.y + lastCard.height
	return { lowestY = lowestY, lastCardY = lastCard.y }
end

---@param mouseX number
---@param mouseY number
---@return boolean
function Holder:isInHolder(mouseX, mouseY)
	local halfWidth = self.width / 2
	local lowest = self:getLowestY()

	local minX = self.x - halfWidth
	local maxX = self.x + halfWidth

	local isInX = mouseX > minX and mouseX < maxX
	local isInY = mouseY > lowest.lastCardY and mouseY < lowest.lowestY

	return isInX == true and isInY == true
end
