local class = require("engine.class")
local EventHandler = require("events.event-handler")

---@class MainMenuEvents: EventHandler
local MainMenuEvents = class.inherit(EventHandler, "MainMenuEvents")

function MainMenuEvents:new()
	local event = EventHandler.new(self)
	return event
end

function MainMenuEvents:handleClick(mouseX, mouseY)
	if ScreenState.currentScreen.type == ScreenTypes.MENU then
		local menuState = ScreenState.screens.MENU
		forEach(menuState.buttons, function(button)
			if button.box:checkInBox(mouseX, mouseY) then
				button.onClick()
			end
		end)
	end
end

return MainMenuEvents
