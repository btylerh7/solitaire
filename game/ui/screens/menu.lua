local class = require("engine.class")
local Button = require("game.ui.button")
local Box = require("engine.box")
local Grid = require("game.ui.distribution.grid")
local PlayButton = require("game.ui.buttons.play")
local ExitButton = require("game.ui.buttons.exit")

---@class MenuScreen
---@field buttons Button[]
---@field playButton Button
---@field type string
---@field isLoaded boolean
local MenuScreen = class.new("MenuScreen")

function MenuScreen:new()
	local menu = setmetatable({}, self)
	self.type = ScreenTypes.MENU
	self.isLoaded = false
	self.buttons = {}

	return menu
end

function MenuScreen:load()
	local startX = love.graphics:getWidth() / 2
	local startY = love.graphics:getHeight() / 2
	---@type Grid
	ButtonGrid =
		Grid:new(Box:new(0, 0, love.graphics.getWidth(), love.graphics:getHeight()), "center", { padding = 15 })
	local buttonColor = { 0.5, 0.5, 1 }

	local playButton = PlayButton:new(Box:new(startX, startY, 200, 120), { color = buttonColor, borderRadius = 10 })
	local exitButton = ExitButton:new(Box:new(startX, startY + 1, 200, 120), { color = buttonColor, borderRadius = 10 })
	self.playButton = playButton
	ButtonGrid:addItem(playButton)
	ButtonGrid:addItem(exitButton)
	ButtonGrid:distributeVertically()
	ButtonGrid:centerItems()
	table.insert(self.buttons, playButton)
	table.insert(self.buttons, exitButton)
	self.isLoaded = true
end

function MenuScreen:update(dt) end

function MenuScreen:draw()
	ButtonGrid:draw()
	-- forEach(self.buttons, function(button)
	-- 	button:draw()
	-- end)
end

return MenuScreen
