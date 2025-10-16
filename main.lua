require("card")
require("holder")
require("holder-game")
require("holder-ace")
require("holder-draw")
require("holder-locations")
require("all-cards")
require("state")

G = {}
G.cardWidth = 48 * 2
G.cardHeight = 64 * 2
G.zoomMultiplier = 1
G.shaders = {}
G.shaders.outline = love.graphics.newShader("shaders/outline.glsl")
States = require("state-machine")
State = State:new()
States.gameState:new()

function love.load()
	HolderLocations:setup()
	AllCards:setup()
	HolderLocations:addShuffledCards(States.gameState.activeCards)
end

function love.update(dt)
	HolderLocations:updateAll(dt)
end

function love.draw()
	love.graphics.setBackgroundColor(0.21, 0.42, 0.16)
	HolderLocations:drawAll()
	States.gameState:draw()
	-- State:draw()
end

function love.mousepressed(x, y, button, isTouch, presses)
	if button == 1 then
		States.gameState.clicked = true
		State.pressed = true
		if presses == 2 then
			State.doubleClick = true
			HolderLocations:doubleClicked(x, y)
		else
			-- HolderLocations:handleClick(x, y)
			HolderLocations:mousepressed(x, y)
		end
	end
end
function love.mousemoved(x, y)
	State:moveCard(x, y)
end
function love.mousereleased(x, y, button)
	if button == 1 then
		State.pressed = false
		State:mousereleased(x, y)
	end
end
