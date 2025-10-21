local Label = require("game.ui.label")
local Box = require("engine.box")
local class = require("engine.object-v2")

---@class WinLabel:Label
local WinLabel = class.inherit(Label, "WinLabel")

function WinLabel:new(x, y)
	local label = Label.new(self, x, y)
	label:setText("You Win!")
	return label
end
function WinLabel:draw()
	if States.gameState.isWin then
		Label.draw(self)
		-- love.graphics.setFont(self.font)
		-- love.graphics.setColor(1, 1, 1)
		-- love.graphics.printf(self.text or "", self.x, self.y, love.graphics:getWidth(), "center")
	end
end

return WinLabel
