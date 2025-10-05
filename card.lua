--- @class Card
Card = {}
Card.__index = Card
ActiveCards = {}

function Card.new(rank, suit, isDisplayed)
	--- @class Card
	local card = setmetatable({}, Card)
	card.x = 0
	card.y = 0
	card.startX = 0
	card.startY = 0
	card.width = 100
	card.height = 150
	card.rank = rank
	card.suit = suit
	card.isDisplayed = isDisplayed
	card.isDragable = false
	card.isMoving = false
	card.sprite = love.graphics.newImage("assets/1.2 Poker cards.png")
	return card
end

function Card:setQuad()
	local columns = 15
	local rows = 5
	local width = self.sprite:getWidth()
	local height = self.sprite:getHeight()
	local cardWidth = G.cardWidth
	local cardHeight = G.cardHeight
	local columnNumber = self.rank
	local rowNumber = self.suit
	if self.isDisplayed == false then
		columnNumber = 1
		rowNumber = 5
	end
	-- Rank will match card number (ex. 2 of hearts will have rank 2)
	local startX = columnNumber * cardWidth
	local startY = (rowNumber * cardHeight) - cardHeight
	local quad = love.graphics.newQuad(startX, startY, cardWidth, cardHeight, width, height)
	self.quad = quad
end

function Card:load() end

function Card:update(dt) end
function Card:updateAll(dt)
	for i, card in ipairs(ActiveCards) do
		card:update(dt)
	end
end

function Card:draw()
	self:setQuad()
	-- love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.draw(self.sprite, self.quad, self.x, self.y)
end

function Card:drawAll()
	for i, card in ipairs(ActiveCards) do
		card:draw()
	end
end
function Card:mousepressed(x, y)
	if self:isInBox(x, y) == true then
		self.startX = self.x
		self.startY = self.y
		self.isMoving = true
	end
end
function Card:mousemoved(x, y)
	if self.isMoving == true then
		self.x = x
		self.y = y
	end
end

---@param currentHolder Holder
function Card:mousereleased(mouseX, mouseY, currentHolder)
	local isInHolder = false
	for index, value in ipairs(HolderLocations.cardSlots) do
		local halfWidth = value.width / 2
		local halfHeight = value.height / 2
		if mouseX > (value.x - halfWidth) and mouseX < (value.x + halfWidth) then
			lowest = value:getLowestY()
			if mouseY > lowest.lastCardY and mouseY < lowest.lowestY then
				print("is in holder")
				value:addCard(self)
				isInHolder = true
				currentHolder:removeCard(self)
			end
		end
	end
	if isInHolder == false then
		print("not in holder")
		self.x = self.startX
		self.y = self.startY
	end
	self.isMoving = false
end

function Card:isInBox(x, y)
	local halfWidth = self.width / 2
	local halfHeight = self.height / 2
	local minX = self.x - halfWidth
	local maxX = self.x + halfWidth
	local minY = self.y - halfHeight
	local maxY = self.y + halfHeight
	if x > minX and x < maxX then
		if y > minY and y < maxY then
			return true
		else
			return false
		end
	else
		return false
	end
end
