local class = require("engine.object-v2")
local Box = require("engine.box")
---@class Label
---@field box Box
---@field text string
---@field fontSize number
---@field color? string
---@field font love.Font
local Label = class.new("Label")

function Label:new(x, y)
	local label = setmetatable({}, self)
	label.box = Box:new(x, y, 0, 0)
	label.text = ""
	label.color = nil
	label.font = G.uiFont
	return label
end

function Label:setText(text)
	self.text = text
end

function Label:draw()
	love.graphics.setFont(self.font)
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf(self.text or "", self.box.x, self.box.y, love.graphics:getWidth(), "left")
end

return Label
