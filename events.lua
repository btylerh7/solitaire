require("functions.functional-programming")

Events = {}

function Events:doubleClicked(mouseX, mouseY)
	print("-----")
	print("-----")
	print("checking double click")
	local isDrawPile = HolderLocations.drawPile:checkInHolder(mouseX, mouseY)
	print("isDrawPile: ", isDrawPile)
	local isAce = filter(HolderLocations.aceSlots, function(holder)
		return holder:checkInHolder(mouseX, mouseY)
	end)
	print("isAce: ", isAce)
	local foundCard = find(States.gameState.activeCards, function(card)
		local isClicked = card:checkIsClicked(mouseX, mouseY)
		local isDisplayed = card.isDisplayed
		local hasParent = card.parent ~= nil

		return isClicked and isDisplayed and hasParent
	end)
	if not isDrawPile and #isAce == 0 then
		print("not draw or ace")
		if foundCard then
			local foundIndex = foundCard.parent:getIndexOfCard(foundCard)
			if foundIndex == #foundCard.parent.cards then
				print("found card")
				local availableAceSlots = filter(HolderLocations.aceSlots, function(holder)
					return holder:checkCanAdd(foundCard.rank, foundCard.suit)
				end)
				if #availableAceSlots > 0 then
					local holder = availableAceSlots[1]
					local parent = foundCard.parent
					foundCard.parent:removeCard(foundCard)
					if parent then
						parent:displayLastCard()
					end
					holder:addCard(foundCard)
					love.audio.play(G.sounds.cardClick)
					holder:setPositions()
					holder:displayLastCard()
				end
			end
		end
	end
	print("-----")
	print("-----")
end
function Events:checkClickType(mouseX, mouseY)
	if HolderLocations.drawPile:checkInHolder(mouseX, mouseY) then
		--No need to check double click
		self:handleClick(mouseX, mouseY)
		return
	end
	local currentTime = love.timer.getTime()
	local timer = States.clickTimer

	local timeBetweenClicks = currentTime - timer.clickTime

	if timeBetweenClicks < timer.clickInterval then
		-- second click within clicking interval... double click
		timer.singleClickPending = false
		self:doubleClicked(mouseX, mouseY)
	else
		-- could be single click
		print("could be single click")
		timer.clickTime = currentTime
		timer.clickX = mouseX
		timer.clickY = mouseY
		timer.singleClickPending = true
	end
end
function Events:handleClick(mouseX, mouseY)
	local clickedHolder = HolderLocations:findHolder(mouseX, mouseY)
	if clickedHolder then
		print("A holder was clicked.")
		print("Type is ", clickedHolder.type)
		switch(clickedHolder.type, {
			[HolderType.FOUNDATION] = function() end,
			[HolderType.STOCK] = function()
				HolderLocations:drawCard()
			end,
			[HolderType.WASTE] = function()
				States:setStartingHolder(clickedHolder)
				States.gameState.moving = true

				if #clickedHolder.cards > 0 then
					table.insert(States.gameState.movingCards.cards, clickedHolder.cards[#clickedHolder.cards])
					clickedHolder:removeCard(clickedHolder.cards[#clickedHolder.cards])
				end
			end,
		}, function()
			print("Handling click of tableau or waste pile")
			local foundCard, foundIndex = find(clickedHolder.cards, function(card)
				local isClicked = card:checkIsClicked(mouseX, mouseY)
				local isDisplayed = card.isDisplayed
				local hasParent = card.parent ~= nil

				return isClicked and isDisplayed and hasParent
			end)
			if foundCard and foundIndex ~= nil then
				print("Card found at index ", foundIndex)
				assert(#States.gameState.movingCards.cards == 0, "No cards should be in moving cards at this point")

				States:setStartingHolder(clickedHolder)
				States.gameState.moving = true

				while #clickedHolder.cards >= foundIndex do
					table.insert(States.gameState.movingCards.cards, clickedHolder.cards[foundIndex])
					clickedHolder:removeCard(clickedHolder.cards[foundIndex])
				end
			end
		end)
	end
end

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
		forEach(States.gameState.movingCards.cards, function(card)
			print("adding to holder")
			holder:addCard(card)
			holder:setPositions()
			holder:displayLastCard()
			love.audio.play(G.sounds.cardClick)
		end)
	end
	local targetHolder = HolderLocations:findHolder(mouseX, mouseY)
	if targetHolder == nil then
		print("No target")
		sendToHolder(startingHolder)
		States:reset()
		return
	end
	local firstCard = States.gameState.movingCards.cards[1]

	local canMove = States.gameState.gameRules:canMove(firstCard, targetHolder, startingHolder)
	if firstCard and canMove then
		print("sending to target")
		sendToHolder(targetHolder)
		startingHolder:displayLastCard()
	else
		print("sending back, can't add")
		sendToHolder(startingHolder)
	end
	States:reset()
end
