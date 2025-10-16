Events = {}

function Events:clicked(mouseX, mouseY)
	print("Checking click at " .. mouseX .. " " .. mouseY)
	---@type Card | nil
	local foundCard = nil
	-- Find the parent holder for clicked card
	for _, card in ipairs(States.gameState.activeCards) do
		local boundingBox = card:getBoundingBox()
		if card:isInBox(mouseX, mouseY, boundingBox.maxY) and card.isDisplayed then
			print("Card found")
			print(card.rank)
			print(card.suit)
			States.gameState.movingCards.startingHolder = card.parentHolder
			foundCard = card
			break
		end
	end
	if foundCard ~= nil then
		local holder = foundCard.parentHolder
		-- Draw pile clicked
		if holder.type == HolderType.DRAW and HolderLocations.drawPile:isInHolder(mouseX, mouseY) then
			HolderLocations:drawCard()
		else
			self:cardDragged(foundCard, mouseX, mouseY)
		end
	end
end

---@param card Card
---@param mouseX number
---@param mouseY number
function Events:cardDragged(card, mouseX, mouseY)
	local holder = card.parentHolder
	if holder ~= nil then
		-- Can't drag in ace holder
		if holder.type == HolderType.ACE then
			return
		end
		local index = holder:getIndexOfCard(card)
		local totalCards = #holder.cards
		if index then
			for i = totalCards, index, -1 do
				table.insert(States.gameState.movingCards.cards, holder.cards[i])
				holder:removeCard(i)
			end
		end
		holder:setCardLocation()
		for index, card in ipairs(States.gameState.movingCards.cards) do
			print("setting moving for " .. #States.gameState.movingCards.cards .. " cards")
			if index == 1 then
				card:setMoving(mouseX, mouseY)
			else
				card:setMoving(mouseX, mouseY + (20 * (index - 1)))
			end
		end
	end
end

function Events:mouseReleased(mouseX, mouseY) end
