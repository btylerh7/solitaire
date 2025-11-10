local class = require("engine.class")

---@class Grid
---@field box Box
---@field items any[]
---@field align "center"|"left"|"right"
---@field padding number
local Grid = class.new("Grid")

---@param opts {padding: number}
function Grid:new(box, alignment, opts)
	local grid = setmetatable({}, self)
	grid.box = box
	grid.align = alignment
	grid.items = {}
	grid.padding = opts.padding or 0
	return grid
end

function Grid:clearButtons()
	self.items = {}
end

function Grid:addItem(item)
	table.insert(self.items, item)
end

function Grid:draw()
	forEach(self.items, function(item)
		item:draw()
	end)
end

function Grid:centerItems()
	local maxY = self.box.y + self.box.height
	local lastItem = self.items[#self.items]
	local lastUsedY = lastItem.box.y + lastItem.box.height
	local remainingSpace = maxY - lastUsedY
	if remainingSpace > 0 then
		forEach(self.items, function(item)
			item.box.y = item.box.y + remainingSpace / 2
		end)
	end
end

function Grid:distributeVertically()
	local usedHeight = 0
	print("Item count" .. #self.items)

	forEach(self.items, function(item)
		usedHeight = usedHeight + item.box.height
	end)

	local remainingHeight = self.box.height - usedHeight - (2 * self.padding)
	local gap = remainingHeight / #self.items - 1
	forEach(self.items, function(item, index)
		if index == 1 then
			print(item.box)
			item.box.y = self.box.y + self.padding
		else
			print(item.box)
			local heightAndGap = item.box.height + gap
			local yVal = self.box.y + (heightAndGap * (index - 1))
			item.box.y = yVal
		end
	end)
end

return Grid
