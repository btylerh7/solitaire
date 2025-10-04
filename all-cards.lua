AllCards = {}

function AllCards:loadCards()
	for i = 1, 12, 1 do
		table.insert(AllCards, Card.new(i, 1, false))
		table.insert(AllCards, Card.new(i, 2, false))
		table.insert(AllCards, Card.new(i, 3, false))
		table.insert(AllCards, Card.new(i, 4, false))
	end
end
function AllCards:shuffle()
	AllCardsShuffled = {}
	math.randomseed(os.time())
	while #AllCards > 0 do
		local randomIndex = math.random(1, #AllCards)
		table.insert(AllCardsShuffled, AllCards[randomIndex])
		table.remove(AllCards, randomIndex)
	end
end
