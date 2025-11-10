local class = require("engine.class")

---@class Button
---@field text string
---@field box Box
---@field opts {color: string, borderRadius: number}
---@field onClick fun()
local Button = class.new("Button")

---@param box Box
---@param text string
---@param opts {color: number[], borderRadius: number, onClick: fun()}
function Button:new(box, text, opts)
	local button = setmetatable({}, self)
	button.box = box
	button.text = text
	button.opts = opts
	if button.opts.onClick then
		self.onClick = opts.onClick
	end
	button:centerXY()
	return button
end

---Love x and y coordinates are the top left of the box. This makes it so a Button can be created
---with the x and y set and make that point be the center instead.
function Button:centerXY()
	local halfWidth = self.box.width / 2
	local halfHeight = self.box.height / 2

	self.box.x = self.box.x - halfWidth
	self.box.y = self.box.y - halfHeight
end

function Button:draw()
	if self.opts.color then
		love.graphics.setColor(self.opts.color[1], self.opts.color[2], self.opts.color[3], 1)
	end
	love.graphics.rectangle(
		"fill",
		self.box.x,
		self.box.y,
		self.box.width,
		self.box.height,
		self.opts.borderRadius or 0,
		self.opts.borderRadius or 0
	)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(self.text, G.buttonFont, self.box.x, self.box.y + 6, self.box.width, "center")
end

return Button
