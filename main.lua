require("events.solitaire")

G = require("globals")
States = require("state.game")
States:new()
ScreenState = require("state.screen"):new()
Events = {
	mainMenu = require("events.main-menu"),
	solitaire = require("events.solitaire"),
}

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
		switch(ScreenState.currentScreen, {
			[ScreenState.screens.SOLITAIRE] = function()
				Events.solitaire:checkClickType(x, y)
			end,
			[ScreenState.screens.MENU] = function()
				Events.mainMenu:handleClick(x, y)
			end,
			[ScreenState.screens.PAUSE] = function()
				Events.mainMenu:handleClick(x, y)
			end,
		})
		-- Events:checkClickType(x, y)
	end
end
function love.mousereleased(x, y, button)
	States.clickTimer:reset()
	switch(ScreenState.currentScreen, {
		[ScreenState.screens.SOLITAIRE] = function()
			Events.solitaire:mouseReleased(x, y)
		end,
	})
	-- Events:mouseReleased(x, y)
end
