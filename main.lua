require("card")
require("holder")
require("holder-game")
require("holder-ace")
require("holder-draw")
require("holder-locations")
require("events")
require("moving-cards")

G = require("globals")
States = require("state")
States.gameState:new()

function love.load()
	HolderLocations:setup()
	HolderLocations:addShuffledCards()
end

function love.update(dt)
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
end

function love.mousepressed(x, y, button)
	if button == 1 then
		Events:clicked(x, y)
	end
end
function love.mousemoved(x, y)
	Events:cardMoving(x, y)
end
