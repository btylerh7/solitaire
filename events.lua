Events = {}

function Events:clicked(mouseX, mouseY)
	print("Checking click at " .. mouseX .. " " .. mouseY)
	for index, card in ipairs(States.gameState.activeCards) do
		local isClicked = card:checkIsClicked(mouseX, mouseY)
		local isDisplayed = card.isDisplayed
		local hasParent = card.parent ~= nil

		if isClicked and isDisplayed and hasParent then
			print("found card")
			States.gameState.movingCards.startingHolder = card.parent
			card.isMoving = true
			card.isClicked = true
			States.gameState.moving = true
			local moving = false
			for _, holderCard in ipairs(card.parent.cards) do
				local cardIndex = card.parent:getIndexOfCard(card)
				if moving then
					table.insert(States.gameState.movingCards.cards, holderCard)
					table.remove(card.parent, cardIndex)
				elseif holderCard.isMoving then
					table.insert(States.gameState.movingCards.cards, holderCard)
					table.remove(card.parent, cardIndex)
					moving = true
				end
			end
			return
		end
	end
end

---@param card Card
---@param mouseX number
---@param mouseY number
function Events:cardDragged(card, mouseX, mouseY) end

function Events:cardMoving(mouseX, mouseY) end

function Events:mouseReleased(mouseX, mouseY)
	States.gameState.moving = false
	if #States.gameState.movingCards.cards == 0 then
		return
	end
	local startingHolder = States.gameState.movingCards.startingHolder
	if startingHolder == nil then
		error("Urgh, no starting holder in mouseReleased")
	end

	---@type fun(holder:Holder)
	local sendToHolder = function(holder)
		for _, card in ipairs(States.gameState.movingCards.cards) do
			print("adding to holder")
			holder:addCard(card)
			card.parent = holder
			card.isMoving = false
			card.isClicked = false
			print("card pos before, x: " .. card.x .. " y: " .. card.y)
			holder:setPositions()
			print("card pos after, x: " .. card.x .. " y: " .. card.y)
		end
	end
	local targetHolder = HolderLocations:findHolder(mouseX, mouseY)
	if targetHolder == nil then
		print("No target")
		print("Moving to holder " .. States.gameState.movingCards.startingHolder.x)
		sendToHolder(States.gameState.movingCards.startingHolder)
		return
	end
	local firstCard = States.gameState.movingCards.cards[1]

	if firstCard and targetHolder:checkCanAdd(firstCard.rank, firstCard.suit) then
		sendToHolder(targetHolder)
	else
		sendToHolder(startingHolder)
	end
	States.gameState.movingCards = {
		cards = {},
		startingHolder = nil,
		targetHolder = nil,
	}
end
