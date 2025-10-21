require("game.entities.card")
require("game.entities.holders.holder")
require("game.entities.holders.holder-game")
require("game.entities.holders.holder-ace")
require("game.entities.holders.holder-draw")
require("game.entities.holder-locations")
require("events")

G = require("globals")
States = require("state")
States:new()
local ScoreLabelClass = require("game.ui.score-label")
local WinLabelClass = require("game.ui.win-label")
local Rules = require("game.rules.rules")
HolderLocations = require("game.entities.holder-locations")

function love.load()
	HolderLocations:setupBoard()
	States.gameState.isBoardSet = true
	-- HolderLocations:setup()
	-- HolderLocations:addShuffledCards()
	scoreLabel = ScoreLabelClass:new(
		LocationConfig.leftSideX,
		love.graphics.getHeight() - 100,
		States.gameState.remainingRedraws
	)
	WinLabel = WinLabelClass:new(LocationConfig.leftSideX, love.graphics:getHeight() - 69)
end

function love.update(dt)
	local _ = dt --just to stop the lsp warning
	scoreLabel:update()
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
			card:move(x, ((index - 1) * G.gameHolderYStep) + y)
		end
	end
end

function love.draw()
	love.graphics.setBackgroundColor(0.21, 0.42, 0.16)
	HolderLocations:drawAll()
	States.gameState:draw()
	WinLabel:draw()
	scoreLabel:draw()
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
