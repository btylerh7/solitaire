local class = require("engine.object-v2")
local Box = require("engine.box")

---@class Animation
---@field box Box
---@field totalColumns number
---@field totalRows number
---@field totalFrames number
---@field currentFrame number
---@field isAnimating boolean
---@field spriteSheet love.Image
---@field timer number
---@field animationRate number
local Animation = class.new("Animation")

---@param totalFrames number: total amount of frames in animation
function Animation:new(x, y, sheetPath, totalColumns, totalRows, totalFrames)
	local anim = setmetatable({}, self)
	anim.spriteSheet = love.graphics.newImage(sheetPath)
	anim.totalColumns = totalColumns
	anim.totalRows = totalRows
	anim.totalFrames = totalFrames
	anim.currentFrame = 1
	anim.isAnimating = false
	anim.timer = 0
	anim.animationRate = 1
	anim.box = Box:new(x, y, anim.spriteSheet:getWidth() / totalColumns, anim.spriteSheet:getHeight() / totalRows)
	return anim
end

function Animation:update(dt)
	if not self.isAnimating then
		return
	end
	self.timer = self.timer + dt

	if self.timer >= self.animationRate then
		if self.currentFrame == self.totalFrames then
			self.currentFrame = 1
		else
			self.timer = 0
			self.currentFrame = self.currentFrame + 1
		end
	end
end

function Animation:draw()
	local sheetWidth = self.spriteSheet:getWidth()
	local sheetHeight = self.spriteSheet:getHeight()
	local stepSizeX = sheetWidth / self.totalColumns
	local stepSizeY = sheetHeight / self.totalRows

	local currentRow = math.ceil(self.currentFrame / self.totalColumns)
	-- local currentColumn = self.totalColumns - (self.currentFrame % self.totalColumns)
	local currentColumn = (self.currentFrame % self.totalColumns)
	if currentColumn == 0 then
		currentColumn = self.totalColumns
	end
	if not self.isAnimating then
		currentColumn = 2
		currentRow = 1
	end

	local xCoord = (currentColumn - 1) * stepSizeX
	local yCoord = (currentRow - 1) * stepSizeY

	local quad = love.graphics.newQuad(xCoord, yCoord, stepSizeX, stepSizeY, self.spriteSheet)
	love.graphics.draw(self.spriteSheet, quad, self.box.x, self.box.y, nil, 2, 2)
end

return Animation
