local class = require("engine.class")
local Button = require("game.ui.button")
local Box = require("engine.box")
local Grid = require("game.ui.distribution.grid")

---@class MenuScreen
---@field buttons Button[]
---@field playButton Button
---@field type string
---@field isLoaded boolean
---@field grid Grid
local MenuScreen = class.new("MenuScreen")

function MenuScreen:new()
	local menu = setmetatable({}, self)
	self.type = ScreenTypes.MENU
	self.isLoaded = false
	self.grid = Grid:new(Box:new(0, 0, love.graphics.getWidth(), love.graphics:getHeight()), "center", { padding = 15 })
	self.buttons = {}

	return menu
end

function MenuScreen:load() end

function MenuScreen:update(dt) end

---@param buttons Button[]
function MenuScreen:addButtons(buttons)
	forEach(buttons, function(button)
		self.grid:addItem(button)
	end)

	self.grid:distributeVertically()
	self.grid:centerItems()

	forEach(buttons, function(button)
		table.insert(self.buttons, button)
	end)
end

function MenuScreen:draw()
	self.grid:draw()
end

return MenuScreen
