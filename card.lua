require("engine/object")
---@class Card:Object
Card = Object:extend()
Card.__index = Card
ActiveCards = {}

---@param rank number
---@param suit number
---@param isDisplayed boolean
function Card.new(rank, suit, isDisplayed)
	--- @class Card
	local card = setmetatable({}, Card)
	card.y = 0
	card.startX = 0
	card.startY = 0
	card.width = G.cardWidth * G.zoomMultiplier
	card.height = G.cardHeight * G.zoomMultiplier
	card.stackHeight = 20
	card.rank = rank
	card.suit = suit
	card.isDisplayed = isDisplayed
	card.isDragable = false
	card.isMoving = false
	card.isInStack = false
	-- card.sprite = love.graphics.newImage("assets/1.2 Poker cards.png")
	card.sprite = love.graphics.newImage("cards/cards-v2.png")
	---@type Holder | nil
	card.parentHolder = nil
	card:setQuad()
	return card
end

function Card:getBoundingBox()
	local box = {
		minX = self.x,
		maxX = self.x + self.width,
		minY = self.y,
		maxY = self.y + self.height,
	}
	if self.isInStack then
		box.maxY = self.y + self.stackHeight
	end
	return box
end

function Card:setQuad()
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
	-- Starts on X = 0 so columnNumber - 1
	local startX = (columnNumber - 1) * cardWidth
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
	-- love.graphics.setShader(G.shaders.outline)
	-- G.shaders.outline:send("outline_color", { 0, 0, 0, 1 })
	-- G.shaders.outline:send("border_thickness", 0.007)
	love.graphics.setBlendMode("alpha", "alphamultiply")
	love.graphics.draw(self.sprite, self.quad, self.x, self.y, nil, G.zoomMultiplier, G.zoomMultiplier)
	-- love.graphics.setShader()
end

---@param x number
---@param y number
---If x and y are within the box's clickable range, will set its moving value to true
function Card:setMoving(x, y)
	local box = self:getBoundingBox()
	if self:isInBox(x, y, box.maxY) then
		self.isMoving = true
	else
		self.isMoving = false
	end
end

---@param mouseX number
---@param mouseY number
---Checks if the released card is inside a game holder and if it can be added
function Card:mousereleased(mouseX, mouseY)
	local isInHolder = false
	for _, value in ipairs(HolderLocations.cardSlots) do
		local halfWidth = value.width / 2
		if mouseX > value.x and mouseX < value.x + value.width then
			local lowest = value:getLowestY()
			if mouseY > lowest.lastCardY and mouseY < lowest.lowestY then
				print("is in holder")
				State:setTargetHolder(value)
				State:transferCards(true)
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

function Card:toggleDisplayed()
	if self.isDisplayed then
		self.isDisplayed = false
	else
		self.isDisplayed = true
	end
	self:setQuad()
end
