local class = require("engine.class")

local SolitaireScreen = require("game.ui.screens.solitaire")
local MenuScreen = require("game.ui.screens.menu")
local MainMenu = require("game.ui.screens.main-menu")
local PauseMenu = require("game.ui.screens.pause")
ScreenTypes = {
	MENU = "menu",
	SOLITAIRE = "solitaire",
	PAUSE = "pause",
}

---@class ScreenState
---@field currentScreen SolitaireScreen | MenuScreen
---@field screens {MENU: MainMenu, SOLITAIRE: SolitaireScreen, PAUSE: PauseScreen}
local ScreenState = class.new("ScreenState")

---@return ScreenState
function ScreenState:new()
	local screenState = setmetatable({}, self)
	screenState.screens = {
		MENU = MainMenu:new(),
		-- OVERWORLD = "overworld",
		PAUSE = PauseMenu:new(),
		SOLITAIRE = SolitaireScreen:new(),
	}
	screenState.currentScreen = screenState.screens.MENU
	return screenState
end

function ScreenState:changeScreen(screen)
	print("change screen triggered")
	print("Screen type: " .. screen.type .. " current screen type: " .. self.currentScreen.type)
	if screen.type == self.currentScreen.type then
		print("Screen is same, not changing")
		return
	end
	print("screen is not same")
	self.currentScreen.isLoaded = false
	self.currentScreen = screen
	if not self.currentScreen.isLoaded then
		self.currentScreen:load()
	end
end

return ScreenState
