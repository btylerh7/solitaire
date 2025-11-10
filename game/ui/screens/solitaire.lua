require("game.entities.card")
require("game.entities.holders.holder")
require("game.entities.holders.holder-game")
require("game.entities.holders.holder-ace")
require("game.entities.holders.holder-draw")
require("game.entities.holder-locations")

local class = require("engine.class")
local ScoreLabelClass = require("game.ui.score-label")
local WinLabelClass = require("game.ui.win-label")
local Rules = require("game.rules.rules")
HolderLocations = require("game.entities.holder-locations")

---@class SolitaireScreen
---@field type string
---@field isLoaded boolean
local SolitaireScreen = class.new("SolitaireScreen")

function SolitaireScreen:new()
	local screen = setmetatable({}, self)
	self.isLoaded = false
	screen.type = ScreenTypes.SOLITAIRE
	return screen
end

function SolitaireScreen:load()
	HolderLocations:setupBoard()
	States.gameState.isBoardSet = true
	scoreLabel = ScoreLabelClass:new(
		LocationConfig.leftSideX,
		love.graphics.getHeight() - 100,
		States.gameState.remainingRedraws
	)
	WinLabel = WinLabelClass:new(LocationConfig.leftSideX, love.graphics:getHeight() - 69)
	self.isLoaded = true
end

function SolitaireScreen:update(dt)
	local _ = dt --just to stop the lsp warning

	if love.keyboard.isDown("escape") then
		ScreenState:changeScreen(ScreenState.screens.PAUSE)
	end

	scoreLabel:update()
	local timer = States.clickTimer
	if timer.singleClickPending then
		local currentTime = love.timer.getTime()
		if currentTime - timer.clickTime > timer.clickInterval then
			timer.singleClickPending = false
			Events.solitaire:handleClick(timer.clickX, timer.clickY)
		end
	end
	if States.gameState.moving then
		local x = love.mouse.getX()
		local y = love.mouse.getY()
		for index, card in ipairs(States.gameState.movingCards.cards) do
			local xValue = x - (card.box.width / 2)
			card:move(xValue, ((index - 1) * G.gameHolderYStep) + y)
		end
	end
end

function SolitaireScreen:draw()
	love.graphics.setBackgroundColor(0.21, 0.42, 0.16)
	HolderLocations:drawAll()
	States.gameState:draw()
	WinLabel:draw()
	scoreLabel:draw()
end

return SolitaireScreen
