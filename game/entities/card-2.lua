local class = require("engine.object-v2")
local Box = require("engine.box")

---@class Card2: Box
---@field suit number
---@field rank number
---@field box Box
---@field isDisplayed boolean
---@field isInStack boolean
---@field parentType string: One of CardParent
---@field parent Holder | nil
---@field setQuad fun(self)
---@field quad love.Quad
local Card2 = class.inherit(Box, "Card")

function Card2:new(x, y, width, height, suit, rank)
	self.box.new(self, x, y, width, height)
	self.suit = suit
	self.rank = rank
end
