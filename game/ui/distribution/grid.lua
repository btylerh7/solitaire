local class = require("engine.class")

---@class Grid
---@field box Box
---@field items any[]
---@field align "center"|"left"|"right"
local Grid = class.new("Grid")

function Grid:new(box, alignment)
	local grid = setmetatable({}, self)
	grid.box = box
	grid.align = alignment
	grid.items = {}
	return grid
end

function Grid:addItem(item)
	table.insert(self.items, item)
end

function Grid:draw()
	forEach(self.items, function(item)
		item:draw()
	end)
end

function Grid:distributeVertically()
	local usedHeight = 0
	print("Item count" .. #self.items)

	forEach(self.items, function(item)
		usedHeight = usedHeight + item.box.height
	end)

	local remainingHeight = self.box.height - usedHeight
	local gap = remainingHeight / #self.items - 1
	forEach(self.items, function(item, index)
		if index == 1 then
			print(item.box)
			item.box.y = self.box.y
		else
			print(item.box)
			local heightAndGap = item.box.height + gap
			local yVal = self.box.y + (heightAndGap * (index - 1))
			item.box.y = yVal
		end
	end)
end

return Grid
