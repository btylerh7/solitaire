AllCards = {}

function AllCards:loadCards()
	for i = 1, 12, 1 do
		table.insert(AllCards, Card.new(i, 1, true))
		table.insert(AllCards, Card.new(i, 2, true))
		table.insert(AllCards, Card.new(i, 3, true))
		table.insert(AllCards, Card.new(i, 4, true))
	end
end
