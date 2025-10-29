local class = require("engine.class")
local Box = require("engine.box")

---@class Card
---@field suit number
---@field rank number
---@field box Box
---@field isDisplayed boolean
---@field isInStack boolean
---@field parentType string: One of CardParent
---@field parent Holder | nil
---@field sprite love.Image
---@field setQuad fun(self)
---@field quad love.Quad
local Card = class.new("Card")

---@return Card
function Card:new(rank, suit)
	local card = setmetatable({}, self)
	card.box = Box:new(0, 0, G.cardWidth, G.cardHeight)
	card.suit = suit
	card.rank = rank
	card.sprite = G.cardSprite
	card.isDisplayed = false
	card.isInStack = true
	card:setQuad()
	return card
end

function Card:getMaxHeight()
	if self.isInStack then
		return G.gameHolderYStep
	else
		return self.box.height
	end
end

function Card:checkIsClicked(x, y)
	return self.box:checkInBox(x, y, self:getMaxHeight())
end

function Card:setQuad()
	local width = self.sprite:getWidth()
	local height = self.sprite:getHeight()
	local cellWidth = width / 13
	local cellHeight = height / 5
	local cardWidth = self.box.width
	local cardHeight = self.box.height
	local columnNumber = self.rank
	local rowNumber = self.suit
	if self.isDisplayed == false then
		columnNumber = 1
		rowNumber = 5
	end
	-- Rank will match card number (ex. 2 of hearts will have rank 2)
	-- Starts on X = 0 so columnNumber - 1
	local startX = (columnNumber - 1) * cellWidth
	local startY = (rowNumber - 1) * cellHeight
	-- print("StartX: ", startX, "StartY: ", startY, "column: ", columnNumber, "row", rowNumber)
	local quad = love.graphics.newQuad(startX, startY, cellWidth, cellHeight, width, height)
	self.quad = quad
end
function Card:draw()
	-- love.graphics.setShader(G.shaders.outline)
	love.graphics.setShader(G.shaders.hearts)
	-- G.shaders.outline:send("outline_color", { 0, 0, 0, 1 })
	-- G.shaders.outline:send("border_thickness", 0.007)
	love.graphics.setBlendMode("alpha", "alphamultiply")
	love.graphics.draw(self.sprite, self.quad, self.box.x, self.box.y, nil, G.zoomMultiplier, G.zoomMultiplier)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setShader()
end

function Card:move(x, y)
	self.box.x = x
	self.box.y = y
end
function Card:debugPrint()
	print("-----------")
	print("CardOld debug print")
	print("CardOld rank: " .. self.rank)
	print("CardOld suit: " .. self.suit)
	print("CardOld is displayed: ", self.isDisplayed)
	print("-----------")
end

return Card
