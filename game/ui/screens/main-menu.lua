local class = require("engine.class")
local MenuScreen = require("game.ui.screens.menu")
local PlayButton = require("game.ui.buttons.play")
local ExitButton = require("game.ui.buttons.exit")
local Box = require("engine.box")

---@class MainMenu: MenuScreen
local MainMenu = class.inherit(MenuScreen, "MainMenu")

function MainMenu:new()
	---@type MenuScreen
	local menu = MenuScreen.new(self)

	return menu
end

function MainMenu:load()
	self.buttons = {}
	self.grid:clearButtons()
	local startX = love.graphics:getWidth() / 2
	local startY = love.graphics:getHeight() / 2
	local buttonColor = { 0.5, 0.5, 1 }

	local playButton = PlayButton:new(Box:new(startX, startY, 200, 120), { color = buttonColor, borderRadius = 10 })
	local exitButton = ExitButton:new(Box:new(startX, startY + 1, 200, 120), { color = buttonColor, borderRadius = 10 })
	self.playButton = playButton
	self:addButtons({ playButton, exitButton })
	self.isLoaded = true
end

return MainMenu
