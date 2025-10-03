--- @class Card
Card = {}
Card.__index = Card
ActiveCards = {}

function Card.new(x, y, rank, suit, isDisplayed)
	--- @class Card
	local card = setmetatable({}, Card)
	card.x = x
	card.y = y
	card.width = 100
	card.height = 150
	card.rank = rank
	card.suit = suit
	card.isDisplayed = isDisplayed
	card.sprite = love.graphics.newImage("assets/1.2 Poker cards.png")
	card:setQuad()

	table.insert(ActiveCards, card)
end

function Card:setQuad()
	local columns = 15
	local rows = 5
	local width = self.sprite:getWidth()
	local height = self.sprite:getHeight()
	local cardWidth = G.cardWidth
	local cardHeight = G.cardHeight
	local columnNumber = self.rank
	local rowNumber = self.suit
	if self.isDisplayed == false then
		columnNumber = 1
		rowNumber = 5
	end
	-- Rank will match card number (ex. 2 of hearts will have rank 2)
	local startX = columnNumber * cardWidth
	local startY = (rowNumber * cardHeight) - cardHeight
	local quad = love.graphics.newQuad(startX, startY, cardWidth, cardHeight, width, height)
	self.quad = quad
end

function Card:load() end

function Card:update(dt) end
function Card:updateAll(dt)
	for i, card in ipairs(ActiveCards) do
		card:update(dt)
	end
end

function Card:draw()
	-- love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.draw(self.sprite, self.quad, self.x, self.y)
end

function Card:drawAll()
	for i, card in ipairs(ActiveCards) do
		card:draw()
	end
end
