Events = {}

function Events:clicked(mouseX, mouseY)
	print("Checking click at " .. mouseX .. " " .. mouseY)
	---@type Card[]
	local foundCards = {}
	local foundCard = false
	for index, card in ipairs(States.gameState.activeCards) do
		local boundingBox = card:getBoundingBox()
		if foundCard == false and card:isInBox(mouseX, mouseY, boundingBox.maxY) and card.isDisplayed then
			foundCard = true
		end
		if foundCard == true then
			table.insert(foundCards, card)
		end
	end
	States.gameState.movingCards.cards = foundCards
	-- States.gameState.movingCards.startingHolder = foundC
end
