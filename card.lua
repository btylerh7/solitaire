require("engine/object")
--- @class Card: Object
Card = Object:new()
Card.__index = Card
ActiveCards = {}

---@param rank number
---@param suit number
---@param isDisplayed boolean
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
	card.isInStack = true
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

function Card:updateAll(dt)
	for i, card in ipairs(ActiveCards) do
		card:update(dt)
	end
end

function Card:draw()
	self:setQuad()
	-- love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.setBlendMode("alpha", "alphamultiply")
	love.graphics.draw(self.sprite, self.quad, self.x, self.y, nil, G.zoomMultiplier, G.zoomMultiplier)
end

function Card:mousepressed(x, y)
	if self.isInStack == true then
		self:setMoving(x, y, 20)
	else
		self:setMoving(x, y)
	end
end

function Card:mousereleased(mouseX, mouseY)
	local isInHolder = false
	for index, value in ipairs(HolderLocations.cardSlots) do
		local halfWidth = value.width / 2
		local halfHeight = value.height / 2
		if mouseX > (value.x - halfWidth) and mouseX < (value.x + halfWidth) then
			local lowest = value:getLowestY()
			if mouseY > lowest.lastCardY and mouseY < lowest.lowestY then
				print("is in holder")
				-- value:addCard(self)
				-- isInHolder = true
				State:setTargetHolder(value)
				State:transferCards(true)
				-- currentHolder:removeCard(self)
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
