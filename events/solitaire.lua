require("functions.functional-programming")
local EventHandler = require("events.event-handler")
local class = require("engine.class")

---@class SolitaireEvents: EventHandler
local SolitaireEvents = class.inherit(EventHandler, "SolitaireEvents")

---@return SolitaireEvents
function SolitaireEvents:new()
	local events = EventHandler.new(self)
	return events
end

function SolitaireEvents:doubleClicked(mouseX, mouseY)
	print("-----")
	print("-----")
	print("checking double click")
	local isDrawPile = false
	if States.gameState.gameRules.useStock then
		isDrawPile = HolderLocations.drawPile:checkInHolder(mouseX, mouseY)
		print("isDrawPile: ", isDrawPile)
	end
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
function SolitaireEvents:handleClick(mouseX, mouseY)
	local clickedHolder = HolderLocations:findHolder(mouseX, mouseY)
	if clickedHolder then
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
			local foundCard, foundIndex = find(clickedHolder.cards, function(card)
				local isClicked = card:checkIsClicked(mouseX, mouseY)
				local isDisplayed = card.isDisplayed
				local hasParent = card.parent ~= nil

				return isClicked and isDisplayed and hasParent
			end)
			if foundCard and foundIndex ~= nil then
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

function SolitaireEvents:mouseReleased(mouseX, mouseY)
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

return SolitaireEvents
