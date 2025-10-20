require("card")
require("holder")
require("holder-game")
require("holder-ace")
require("holder-draw")
require("holder-locations")
require("events")
local Label = require("label")

G = require("globals")
States = require("state")
States:new()
local ScoreLabel = require("score-label")
local WinLabel = require("win-label")

function love.load()
	HolderLocations:setup()
	HolderLocations:addShuffledCards()
	ScoreLabel1 = ScoreLabel:new(LocationConfig.leftSideX, love.graphics.getHeight() - 100)
	ScoreLabel1:setText("Remaining Redraws: " .. ScoreLabel.remainingRedraws)
	WinLabel1 = WinLabel:new(love.graphics:getWidth() / 2, love.graphics:getHeight() / 2)
end

function love.update(dt)
	ScoreLabel1:update()
	local timer = States.clickTimer
	if timer.singleClickPending then
		local currentTime = love.timer.getTime()
		if currentTime - timer.clickTime > timer.clickInterval then
			timer.singleClickPending = false
			Events:clicked(timer.clickX, timer.clickY)
		end
	end
	if States.gameState.moving then
		local x = love.mouse.getX()
		local y = love.mouse.getY()
		for index, card in ipairs(States.gameState.movingCards.cards) do
			card.x = x
			card.y = ((index - 1) * G.gameHolderYStep) + y
		end
	end
end

function love.draw()
	love.graphics.setBackgroundColor(0.21, 0.42, 0.16)
	HolderLocations:drawAll()
	States.gameState:draw()
	WinLabel1:draw()
	ScoreLabel1:draw()
end

function love.mousepressed(x, y, button, _, presses)
	if button == 1 then
		Events:checkClickType(x, y)
	end
end
function love.mousereleased(x, y, button)
	States.clickTimer:reset()
	Events:mouseReleased(x, y)
end
