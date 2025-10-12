AllCards = {}
---All Cards that have been shuffled and added to the game
---@type Card[]
ActiveCards = {}

function AllCards:loadCards()
	for i = 1, 13, 1 do
		table.insert(AllCards, Card.new(i, 1, false))
		table.insert(AllCards, Card.new(i, 2, false))
		table.insert(AllCards, Card.new(i, 3, false))
		table.insert(AllCards, Card.new(i, 4, false))
	end
end
function AllCards:shuffle()
	ActiveCards = {}
	math.randomseed(os.time())
	while #AllCards > 0 do
		local randomIndex = math.random(1, #AllCards)
		table.insert(ActiveCards, AllCards[randomIndex])
		table.remove(AllCards, randomIndex)
	end
end
