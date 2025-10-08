require("engine/base")
---@class Object: Base
---@field x number
---@field y number
---@field width number
---@field height number
Object = Base:extend()

function Object:init()
	self:new()
end
function Object:new()
	self.isMoving = false
	self.x = 0
	self.y = 0
	self.width = 0
	self.height = 0
end
function Object:load() end

function Object:update(dt) end
function Object:draw() end

function Object:move(x, y)
	if self.isMoving == true then
		self.x = x
		self.y = y
	end
end

function Object:isInBox(x, y, maxHeight)
	local minX = self.x
	local maxX = self.x + self.width
	local maxY = 0
	if maxHeight then
		maxY = maxHeight + self.y
	else
		maxY = self.height + self.y
	end

	if x > minX and x < maxX then
		if y > self.y and y < maxY then
			return true
		else
			return false
		end
	else
		return false
	end
end

function Object:setMoving(x, y, maxHeight)
	local topY = self.y
	if y < topY then
		self.isMoving = false
		return
	end
	if self:isInBox(x, y, maxHeight) == true then
		self.startX = self.x
		self.startY = self.y
		self.isMoving = true
	else
		self.isMoving = false
	end
end
