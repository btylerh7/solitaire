Events = {}

function Events:clicked(mouseX, mouseY)
	print("Checking click at " .. mouseX .. " " .. mouseY)
	---@type Card | nil
	local foundCard = nil
	-- Find the parent holder for clicked card
	for _, card in ipairs(States.gameState.activeCards) do
		local boundingBox = card:getBoundingBox()
		if card:isInBox(mouseX, mouseY, boundingBox.maxY) and card.isDisplayed then
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

function Events:cardDragged(card, mouseX, mouseY)
	local holder = card.parentHolder
	-- Can't drag in ace holder
	if holder.type == HolderType.ACE then
		return
	end
	-- local index = card:
end
