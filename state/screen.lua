local class = require("engine.class")

local SolitaireScreen = require("game.ui.screens.solitaire")

local Screen = {
	MENU = "menu",
	OVERWORLD = "overworld",
	PAUSE = "pause",
	SOLITAIRE = "solitaire",
}

---@class ScreenState
---@field currentScreen SolitaireScreen
local ScreenState = class.new("ScreenState")

function ScreenState:new()
	local screenState = setmetatable({}, self)
	screenState.currentScreen = SolitaireScreen:new()
	return screenState
end

function ScreenState:changeScreen(screen)
	if not screen == self.currentScreen then
		-- Make sure screen is in the defined Screens object
		forEach(Screen, function(currScreen)
			if screen == currScreen then
				self.currentScreen = screen
			end
		end)
	end
end

return ScreenState
