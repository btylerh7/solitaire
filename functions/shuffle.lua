function setUpCards()
	local cards = loadCards()
	return shuffle(cards)
end

---@return Card[]
function loadCards()
	local cards = {}
	for i = 1, 13, 1 do
		table.insert(cards, Card.new(i, 1, false))
		table.insert(cards, Card.new(i, 2, false))
		table.insert(cards, Card.new(i, 3, false))
		table.insert(cards, Card.new(i, 4, false))
	end
	return cards
end

---@param cards Card[]
---@return Card[]
function shuffle(cards)
	local activeCards = {}
	math.randomseed(os.time())
	while #cards > 0 do
		local randomIndex = math.random(1, #cards)
		table.insert(activeCards, cards[randomIndex])
		table.remove(cards, randomIndex)
	end
	return activeCards
end
