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
	if not next(self.cards) then
		love.graphics.setColor(0.21, 0.30, 0.16)
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
		love.graphics.setColor(1, 1, 1)
	end
	local yStep = 0
	local xStep = 0
	if self.type == "game" then
		yStep = 20
	end
	if self.type == "drawn" then
		xStep = 20
	end
	for index, card in ipairs(self.cards) do
		local currentXStep = (index - 1) * xStep
		local currentYStep = (index - 1) * yStep
		card.x = self.x + currentXStep
		card.y = self.y + currentYStep
		card:draw()
	end
end

---@param card Card
function Holder:addCard(card)
	table.insert(self.cards, card)
end
