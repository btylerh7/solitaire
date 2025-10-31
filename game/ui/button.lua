local class = require("engine.class")
local Label = require("game.ui.label")
local Box = require("engine.box")

---@class Button
---@field text string
---@field box Box
---@field opts {color: string, fontSize: number}
local Button = class.new("Button")

---@param box Box
---@param text string
---@param opts {color: number[], fontSize: number}
function Button:new(box, text, opts)
	local button = setmetatable({}, self)
	self.box = box
	button.text = text
	button.opts = opts
	return button
end

function Button:draw()
	if self.opts.color then
		love.graphics.setColor(self.opts.color[1], self.opts.color[2], self.opts.color[3], 1)
	end
	love.graphics.rectangle("fill", self.box.x, self.box.y, self.box.width, self.box.height)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(self.text, self.box.x, self.box.y + (self.box.height / 2) - 12, self.box.width, "center")
end

return Button
