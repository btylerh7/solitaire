local Label = require("label")
---@class ScoreLabel: Label
---@field remainingRedraws number
local ScoreLabel = Label:extend()

function ScoreLabel:new(x, y)
	local label = Label:new(x, y)
	self.y = label.y
	self.x = label.x
	self.color = label.color
	self:setRemainingRedraws()
	return self
end

function ScoreLabel:update()
	self:setRemainingRedraws()
end

function ScoreLabel:draw()
	if not States.gameState.isWin then
		love.graphics.setFont(self.font)
		love.graphics.setColor(1, 1, 1)
		love.graphics.printf(self.text or "", self.x, self.y, love.graphics:getWidth(), "center")
	end
end

function ScoreLabel:setRemainingRedraws()
	self.remainingRedraws = States.gameState.remainingRedraws
	self:setText("Remaining redraws: " .. self.remainingRedraws)
end

return ScoreLabel
