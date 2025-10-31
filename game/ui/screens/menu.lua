local class = require("engine.class")
local Button = require("game.ui.button")
local Box = require("engine.box")

---@class MenuScreen
---@field buttons Button[]
local MenuScreen = class.new("MenuScreen")

function MenuScreen:new()
	local menu = setmetatable({}, self)
	self.buttons = {}

	return menu
end

function MenuScreen:load()
	local startX = love.graphics:getWidth() / 2
	local startY = love.graphics:getHeight() / 2
	local playButton = Button:new(Box:new(startX, startY, 200, 200), "Play Game", { color = { 1, 0, 1 } })
	table.insert(self.buttons, playButton)
end

function MenuScreen:update(dt) end

function MenuScreen:draw()
	forEach(self.buttons, function(button)
		button:draw()
	end)
end

return MenuScreen
