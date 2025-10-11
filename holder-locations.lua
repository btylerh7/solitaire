LocationConfig = {
	stepCount = 125,
	topRowY = 15,
	cardRowY = 250,
	leftSideX = 50,
	aceAreaX = love.graphics.getWidth() / 2,
}
function steppedX(startingValue, index)
	return startingValue + (LocationConfig.stepCount * (index - 1))
end

---@class HolderLocations
---@field cardSlots GameHolder[]
---@field aceSlots AceHolder[]
HolderLocations = {}

function HolderLocations:setup()
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

---@param cards Card[]
function HolderLocations:addShuffledCards(cards)
	for i = 1, 7, 1 do
		for _ = 1, i, 1 do
			self.cardSlots[i]:addCard(table.remove(cards, #cards))
		end
		self.cardSlots[i].cards[i].isDisplayed = true
		self.cardSlots[i].cards[i].isDragable = true
		self.cardSlots[i]:setCardLocation()
	end

	while #cards > 0 do
		cards[#cards].isDisplayed = false
		self.drawPile:addCard(table.remove(cards, #cards))
	end
end

function HolderLocations:setDisplayed() end

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
		nextCard.isDisplayed = true
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
			currentCard.isDisplayed = false
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
			topDrawnCard:mousepressed(x, y)
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

	-- Check if card in drawn pile clicked
	if holderType == HolderType.DRAW then
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
