Card = {}
Card.__index = Card
ActiveCards = {}

function Card.new(x, y)
	local card = setmetatable({}, Card)
	card.x = x
	card.y = y
	card.width = 100
	card.height = 150
	table.insert(ActiveCards, card)
end

function Card:load() end

function Card:update(dt) end
function Card:updateAll(dt)
	for i, card in ipairs(ActiveCards) do
		card:update(dt)
	end
end

function Card:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Card:drawAll()
	for i, card in ipairs(ActiveCards) do
		card:draw()
	end
end
