--- @class Holder
--- @field x number
--- @field y number
--- @field width number
--- @field height number
--- @field type string
--- @field cards Card[]
Holder = {}
Holder.__index = Holder

function Holder.new(x, y, type)
	local holder = setmetatable({}, Holder)
	holder.x = x
	holder.y = y
	holder.width = G.cardWidth
	holder.height = G.cardHeight
	holder.cards = {}
	holder.type = type

	return holder
end

function Holder:load() end
function Holder:update(dt) end

function Holder:draw()
	love.graphics.setColor(0.21, 0.30, 0.16)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	for index, card in ipairs(self.cards) do
	end
end
