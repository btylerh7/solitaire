---@class Label:Base
local Label = Base:extend()

function Label:new(x, y)
	self.text = ""
	self.fontSize = 69
	self.color = nil
	self.x = x
	self.y = y
	self.font = G.uiFont
	return self
end

function Label:setText(text)
	self.text = text
end

function Label:draw()
	love.graphics.setFont(self.font)
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf(self.text or "", self.x, self.y, love.graphics:getWidth(), "center")
end

return Label
