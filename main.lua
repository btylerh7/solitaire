require("events")

G = require("globals")
States = require("state.game")
States:new()
ScreenState = require("state.screen"):new()

function love.load()
	ScreenState.currentScreen:load()
end

function love.update(dt)
	ScreenState.currentScreen:update(dt)
end

function love.draw()
	ScreenState.currentScreen:draw()
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
