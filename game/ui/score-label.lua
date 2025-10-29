local class = require("engine.class")
local Label = require("game.ui.label")

---@class ScoreLabel: Label
---@field remainingRedraws number
local ScoreLabel = class.inherit(Label, "ScoreLabel")

---@return ScoreLabel
function ScoreLabel:new(x, y, remainindRedraws)
	local label = Label.new(self, x, y)
	label.remainingRedraws = remainindRedraws
	return label
end

function ScoreLabel:update()
	self:setRemainingRedraws()
end

function ScoreLabel:draw()
	if not States.gameState.isWin and States.gameState.gameRules.useStock then
		Label.draw(self)
		-- love.graphics.setFont(self.font)
		-- love.graphics.setColor(1, 1, 1)
		-- love.graphics.printf(self.text or "", self.box.x, self.box.y, love.graphics:getWidth(), "center")
	end
end

function ScoreLabel:setRemainingRedraws()
	self.remainingRedraws = States.gameState.remainingRedraws
	self:setText("Remaining redraws: " .. self.remainingRedraws)
end

return ScoreLabel
