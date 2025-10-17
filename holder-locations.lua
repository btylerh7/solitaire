local Utils = require("utils.utils")
LocationConfig = {
	stepCount = 125,
	topRowY = 15,
	cardRowY = 250,
	leftSideX = 50,
	aceAreaX = love.graphics.getWidth() / 2,
}

---@class HolderLocations
---@field cardSlots GameHolder[]
---@field aceSlots AceHolder[]
HolderLocations = {}

function HolderLocations:setup()
	local steppedX = function(startingValue, index)
		return startingValue + (LocationConfig.stepCount * (index - 1))
	end
	local startX = LocationConfig.leftSideX
	local startY = LocationConfig.topRowY
	HolderLocations.drawPile = DrawHolder:new(steppedX(startX, 1), startY, "draw")
	HolderLocations.drawnPile = DrawHolder:new(steppedX(startX, 2), startY, "drawn")

	startX = LocationConfig.aceAreaX
	startY = LocationConfig.topRowY
	HolderLocations.aceSlots = {}
	HolderLocations.cardSlots = {}

	table.insert(HolderLocations.aceSlots, AceHolder:new(steppedX(startX, 1), startY, "ace"))
	table.insert(HolderLocations.aceSlots, AceHolder:new(steppedX(startX, 2), startY, "ace"))
	table.insert(HolderLocations.aceSlots, AceHolder:new(steppedX(startX, 3), startY, "ace"))
	table.insert(HolderLocations.aceSlots, AceHolder:new(steppedX(startX, 4), startY, "ace"))

	startX = LocationConfig.leftSideX
	startY = LocationConfig.cardRowY

	table.insert(HolderLocations.cardSlots, GameHolder:new(steppedX(startX, 1), startY, "game"))
	table.insert(HolderLocations.cardSlots, GameHolder:new(steppedX(startX, 2), startY, "game"))
	table.insert(HolderLocations.cardSlots, GameHolder:new(steppedX(startX, 3), startY, "game"))
	table.insert(HolderLocations.cardSlots, GameHolder:new(steppedX(startX, 4), startY, "game"))
	table.insert(HolderLocations.cardSlots, GameHolder:new(steppedX(startX, 5), startY, "game"))
	table.insert(HolderLocations.cardSlots, GameHolder:new(steppedX(startX, 6), startY, "game"))
	table.insert(HolderLocations.cardSlots, GameHolder:new(steppedX(startX, 7), startY, "game"))
end

--- Uses States.gameState.activeCards to place cards in correct spots
function HolderLocations:addShuffledCards()
	local cardsIndex = 1
	local lastCardIndex = #States.gameState.activeCards
	-- Once for each game holder
	for i = 1, 7, 1 do
		for j = 1, i, 1 do
			local card = States.gameState.activeCards[cardsIndex]
			local currentHolder = self.cardSlots[i]
			card.parent = currentHolder
			card.isInStack = j ~= i

			--If card is last in holder, display it
			card.isDisplayed = j == i
			card:setQuad()
			currentHolder:addCard(card)
			cardsIndex = cardsIndex + 1
		end
	end
	-- Add rest to draw pile
	for i = cardsIndex, lastCardIndex, 1 do
		local card = States.gameState.activeCards[i]
		local currentHolder = self.drawPile

		card.parent = currentHolder
		card.isDisplayed = false
		card.isInStack = false

		currentHolder:addCard(card)
	end
end

--- @param card Card
--- @param slot string
function HolderLocations:addCard(card, slot)
	if self[slot] then
		table.insert(self[slot].cards, card)
	end
end

function HolderLocations:updateAll(dt)
	self.drawPile:update(dt)
	self.drawnPile:update(dt)
	for index, value in ipairs(self.cardSlots) do
		value:update(dt)
	end
	for index, value in ipairs(self.aceSlots) do
		value:update(dt)
	end
end
function HolderLocations:drawAll()
	self.drawPile:draw()
	self.drawnPile:draw()
	for index, value in ipairs(self.cardSlots) do
		value:draw()
	end
	for index, value in ipairs(self.aceSlots) do
		value:draw()
	end
end

---Used when draw pile is clicked to reveal extra card
function HolderLocations:drawCard()
	if #self.drawPile.cards > 0 then
		local nextCard = self.drawPile.cards[#self.drawPile.cards]
		nextCard:toggleDisplayed()
		nextCard.isDragable = true
		self.drawnPile:addCard(nextCard)
		self.drawPile:removeCard(#self.drawPile.cards)
		return
	end
	if #self.drawPile == 0 and State.remainingRedraws > 0 then
		print("time to reset")
		while #self.drawnPile.cards > 0 do
			local currentCard = self.drawnPile.cards[#self.drawnPile.cards]
			currentCard.isDragable = false
			-- currentCard.isDisplayed = false
			currentCard:toggleDisplayed()
			self.drawPile:addCard(currentCard)
			self.drawnPile:removeCard(#self.drawnPile.cards)
		end
		State.remainingRedraws = State.remainingRedraws - 1
		return
	end
end

function HolderLocations:getHolderType(x, y)
	local gameHolder = y > LocationConfig.cardRowY
	local aceHolder = not gameHolder and x > LocationConfig.aceAreaX
	local drawPileHolder = not aceHolder and x > LocationConfig.leftSideX
	if gameHolder then
		return HolderType.GAME
	elseif aceHolder then
		return HolderType.ACE
	elseif drawPileHolder then
		return HolderType.DRAW
	else
		return nil
	end
end

---@param card Card
--- Add to ace slot if available
function HolderLocations:checkAceSlots(card)
	for _, holder in ipairs(self.aceSlots) do
		local canAdd = holder:checkCanAdd(card.rank, card.suit)
		if canAdd == true then
			print("Adding to ace holder")
			print(card.rank)
			print(card.suit)
			State:setTargetHolder(holder)
			State:transferCards(canAdd)
			self.doubleClick = false
			return
		end
	end
	self.doubleClick = false
	return
end

function HolderLocations:doubleClicked(x, y)
	print("checking double click")
	local holderType = self:getHolderType(x, y)
	if holderType == HolderType.ACE then
		return
	end
	print("Holder type is ", holderType)

	if holderType == HolderType.DRAW then
		local isClicked = self.drawnPile:checkIsClicked(x, y)
	end
	if holderType == HolderType.GAME then
		---@type GameHolder | nil
		local clickedHolder = nil
		for _, holder in ipairs(self.cardSlots) do
			if holder:checkIsClicked(x, y) then
				print("found clicked holder")
				clickedHolder = holder
				break
			end
		end
		if clickedHolder then
			print("Total cards in holder is ", #clickedHolder.cards)
			local card = clickedHolder.cards[#clickedHolder.cards]
			print("Card is ", card.rank, card.suit)
			if card then
				self:checkAceSlots(card)
			end
		end
	end
end

function HolderLocations:handleClick(x, y)
	print("x: " .. x .. " y: " .. y)
	---@type Card | nil
	local clickedCard = nil
	for i, card in ipairs(ActiveCards) do
		local bounds = card:getBoundingBox()
		local isInBox = card:isInBox(x, y, bounds.maxY)
		if isInBox then
			clickedCard = card
			print("card clicked: " .. clickedCard.rank .. " " .. clickedCard.suit)
			break
		end
	end
	if clickedCard == nil then
		return
	end

	local holderType = clickedCard.parentHolder.type
	print(clickedCard.parentHolder.type)
	if holderType == HolderType.DRAW then
		local lastCard = clickedCard.parentHolder.cards[#clickedCard.parentHolder.cards]
		if not lastCard.isDisplayed then
			self:drawCard()
			return
		else
		end
	end
end

function HolderLocations:mousepressed(x, y)
	local holderType = self:getHolderType(x, y)
	if holderType == nil then
		return
	end

	-- Check if draw pile clicked
	if holderType == HolderType.DRAW then
		if self.drawPile:isInHolder(x, y) == true then
			self:drawCard()
			return
		elseif #self.drawnPile.cards > 0 then
			local topDrawnCard = self.drawnPile.cards[#self.drawnPile.cards]
			topDrawnCard:setMoving(x, y)
			if topDrawnCard.isMoving == true then
				State:setMoving(self.drawnPile, topDrawnCard)
				return
			end
			for _, card in ipairs(self.drawnPile.cards) do
				if card.isDragable then
					if card:isInBox(x, y) then
						card:setMoving(x, y, 20)
					else
						card:setMoving(x, y)
					end
				end
			end
		end
	end

	-- Check if game holder card clicked
	if holderType == HolderType.GAME then
		for _, holder in pairs(self.cardSlots) do
			local result = holder:checkIsClicked(x, y)
			if result == true then
				break
			end
		end
	end
end
function HolderLocations:move(x, y)
	for _, holder in pairs(self.cardSlots) do
		for _, card in ipairs(holder.cards) do
			if card.isMoving == true then
				card:move(x, y)
			end
		end
	end
end

function HolderLocations:mousereleased(x, y)
	for index, holder in pairs(self.cardSlots) do
		if #State.currentlyMoving.cards > 0 then
			State.currentlyMoving.cards[1]:mousereleased(x, y, holder)
		end
		for index, card in ipairs(holder.cards) do
			if card.isMoving == true then
				card:mousereleased(x, y, holder)
			end
		end
	end
end
