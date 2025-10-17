require("engine/object")

CardParent = {
	ACE = "ace",
	DRAW = "draw",
	DRAWN = "drawn",
	MOVING = "moving",
}

---@class Card:Object
---@field rank number
---@field suit number
---@field width number
---@field height number
---@field isDisplayed boolean
---@field isInStack boolean
---@field parentType string: One of CardParent
---@field parent Holder | nil
---@field x number
---@field y number
---@field setQuad fun(self)
---@field quad love.Quad
Card = Object:extend()
Card.__index = Card
ActiveCards = {}

---@param rank number
---@param suit number
---@param isDisplayed boolean
function Card.new(rank, suit, isDisplayed)
	--- @class Card
	local card = setmetatable({}, Card)
	card.sprite = love.graphics.newImage("cards/cards-v2.png")
	card.rank = rank
	card.suit = suit
	card.width = G.cardWidth
	card.height = G.cardHeight
	card.isDisplayed = isDisplayed
	card:setQuad()
	return card
end

function Card:checkIsClicked(x, y)
	local boundingBox = self:getBoundingBox()
	if self.isInStack then
		boundingBox.maxY = boundingBox.minY + G.gameHolderYStep
	end
	return x > boundingBox.minX and x < boundingBox.maxX and y > boundingBox.minY and y < boundingBox.maxY
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

function Card:draw()
	-- love.graphics.setShader(G.shaders.outline)
	-- G.shaders.outline:send("outline_color", { 0, 0, 0, 1 })
	-- G.shaders.outline:send("border_thickness", 0.007)
	love.graphics.setBlendMode("alpha", "alphamultiply")
	love.graphics.draw(self.sprite, self.quad, self.x, self.y, nil, G.zoomMultiplier, G.zoomMultiplier)
	-- love.graphics.setShader()
end

function Card:debugPrint()
	print("-----------")
	print("Card debug print")
	print("Card rank: " .. self.rank)
	print("Card suit: " .. self.suit)
	print("Card is displayed: ", self.isDisplayed)
	print("-----------")
end
