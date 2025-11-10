local class = require("engine.class")
local MenuScreen = require("game.ui.screens.menu")
local Box = require("engine.box")
local PlayButton = require("game.ui.buttons.play")
local QuitButton = require("game.ui.buttons.quit")

---@class PauseScreen: MenuScreen
local PauseScreen = class.inherit(MenuScreen, "PauseScreen")

function PauseScreen:new()
	---@type PauseScreen
	local menu = MenuScreen.new(self)
	menu.type = ScreenTypes.PAUSE
	return menu
end

function PauseScreen:load()
	self.isLoaded = false
	self.buttons = {}
	self.grid:clearButtons()
	local startX = love.graphics:getWidth() / 2
	local startY = love.graphics:getHeight() / 2
	local buttonColor = { 0.5, 0.5, 1 }

	local playButton = PlayButton:new(Box:new(startX, startY, 200, 120), { color = buttonColor, borderRadius = 10 })

	local quitGameButton = QuitButton:new(Box:new(startX, startY, 200, 120), { color = buttonColor, borderRadius = 10 })
	self.playButton = playButton
	self:addButtons({ playButton, quitGameButton })
	self.isLoaded = true
end

return PauseScreen
