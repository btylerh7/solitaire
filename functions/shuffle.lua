local Card = require("game.entities.card")

---@return Card[]
local function loadCards()
	local cards = {}
	for i = 1, 13, 1 do
		table.insert(cards, Card:new(i, 1))
		table.insert(cards, Card:new(i, 2))
		table.insert(cards, Card:new(i, 3))
		table.insert(cards, Card:new(i, 4))
	end
	return cards
end

---@param cards Card[]
---@return Card[]
local function shuffle(cards)
	local activeCards = {}
	math.randomseed(os.time())
	while #cards > 0 do
		local randomIndex = math.random(1, #cards)
		table.insert(activeCards, cards[randomIndex])
		table.remove(cards, randomIndex)
	end
	return activeCards
end

function setUpCards()
	local cards = loadCards()
	return shuffle(cards)
end
