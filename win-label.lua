local Label = require("label")
local WinLabel = Label:extend()

function WinLabel:new(x, y)
	local label = Label:new(x, y)
	self.y = label.y
	self.x = label.x
	self.color = label.color
	self:setText("You Win!")
	return self
end
function WinLabel:draw()
	if States.gameState.isWin then
		love.graphics.setFont(self.font)
		love.graphics.setColor(1, 1, 1)
		love.graphics.printf(self.text or "", self.x, self.y, love.graphics:getWidth(), "center")
	end
end

return WinLabel
