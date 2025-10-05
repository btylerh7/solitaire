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
---@field cardSlots Holder[]
---@field aceSlots Holder[]
HolderLocations = {}

function HolderLocations:setup()
	local startX = LocationConfig.leftSideX
	local startY = LocationConfig.topRowY
	HolderLocations.drawPile = Holder.new(steppedX(startX, 1), startY, "draw")
	HolderLocations.drawnPile = Holder.new(steppedX(startX, 2), startY, "drawn")

	startX = LocationConfig.aceAreaX
	startY = LocationConfig.topRowY
	HolderLocations.aceSlots = {}
	HolderLocations.cardSlots = {}

	table.insert(HolderLocations.aceSlots, Holder.new(steppedX(startX, 1), startY, "ace"))
	table.insert(HolderLocations.aceSlots, Holder.new(steppedX(startX, 2), startY, "ace"))
	table.insert(HolderLocations.aceSlots, Holder.new(steppedX(startX, 3), startY, "ace"))
	table.insert(HolderLocations.aceSlots, Holder.new(steppedX(startX, 4), startY, "ace"))

	startX = LocationConfig.leftSideX
	startY = LocationConfig.cardRowY

	table.insert(HolderLocations.cardSlots, Holder.new(steppedX(startX, 1), startY, "game"))
	table.insert(HolderLocations.cardSlots, Holder.new(steppedX(startX, 2), startY, "game"))
	table.insert(HolderLocations.cardSlots, Holder.new(steppedX(startX, 3), startY, "game"))
	table.insert(HolderLocations.cardSlots, Holder.new(steppedX(startX, 4), startY, "game"))
	table.insert(HolderLocations.cardSlots, Holder.new(steppedX(startX, 5), startY, "game"))
	table.insert(HolderLocations.cardSlots, Holder.new(steppedX(startX, 6), startY, "game"))
	table.insert(HolderLocations.cardSlots, Holder.new(steppedX(startX, 7), startY, "game"))
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

function HolderLocations:mousepressed(x, y)
	for index, holder in pairs(self.cardSlots) do
		for index, card in ipairs(holder.cards) do
			if card.isDragable == true then
				card:mousepressed(x, y)
			end
		end
	end
end
function HolderLocations:mousemoved(x, y)
	for index, holder in pairs(self.cardSlots) do
		for index, card in ipairs(holder.cards) do
			if card.isMoving == true then
				card:mousemoved(x, y)
			end
		end
	end
end

function HolderLocations:mousereleased(x, y)
	for index, holder in pairs(self.cardSlots) do
		for index, card in ipairs(holder.cards) do
			if card.isMoving == true then
				card:mousereleased(x, y, holder)
			end
		end
	end
end
