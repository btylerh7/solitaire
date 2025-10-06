---@class Object
---@field isMoving boolean
---@field x number
---@field y number
---@field width number
---@field height number
Object = {}
Object.__index = Object

function Object:new()
	local object = setmetatable({}, Object)
	return object
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

function Object:isInBox(x, y)
	local halfWidth = self.width / 2
	local halfHeight = self.height / 2
	local minX = self.x - halfWidth
	local maxX = self.x + halfWidth
	local minY = self.y - halfHeight
	local maxY = self.y + halfHeight
	if x > minX and x < maxX then
		if y > minY and y < maxY then
			return true
		else
			return false
		end
	else
		return false
	end
end

function Object:setMoving(x, y)
	if self:isInBox(x, y) == true then
		self.startX = self.x
		self.startY = self.y
		self.isMoving = true
	else
		self.isMoving = false
	end
end
