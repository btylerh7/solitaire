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
HolderLocations = {}

function HolderLocations:setup()
	local startX = LocationConfig.leftSideX
	local startY = LocationConfig.topRowY
	HolderLocations.drawPile = Holder.new(steppedX(startX, 1), startY, "draw")
	HolderLocations.drawnPile = Holder.new(steppedX(startX, 2), startY, "drawn")

	startX = LocationConfig.aceAreaX
	startY = LocationConfig.topRowY

	HolderLocations.aceSlot1 = Holder.new(steppedX(startX, 1), startY, "ace")
	HolderLocations.aceSlot2 = Holder.new(steppedX(startX, 2), startY, "ace")
	HolderLocations.aceSlot3 = Holder.new(steppedX(startX, 3), startY, "ace")
	HolderLocations.aceSlot4 = Holder.new(steppedX(startX, 4), startY, "ace")

	startX = LocationConfig.leftSideX
	startY = LocationConfig.cardRowY

	HolderLocations.cardSlot1 = Holder.new(steppedX(startX, 1), startY, "game")
	HolderLocations.cardSlot2 = Holder.new(steppedX(startX, 2), startY, "game")
	HolderLocations.cardSlot3 = Holder.new(steppedX(startX, 3), startY, "game")
	HolderLocations.cardSlot4 = Holder.new(steppedX(startX, 4), startY, "game")
	HolderLocations.cardSlot5 = Holder.new(steppedX(startX, 5), startY, "game")
	HolderLocations.cardSlot6 = Holder.new(steppedX(startX, 6), startY, "game")
	HolderLocations.cardSlot7 = Holder.new(steppedX(startX, 7), startY, "game")
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
	self.aceSlot1:update(dt)
	self.aceSlot2:update(dt)
	self.aceSlot3:update(dt)
	self.aceSlot4:update(dt)
	self.cardSlot1:update(dt)
	self.cardSlot2:update(dt)
	self.cardSlot3:update(dt)
	self.cardSlot4:update(dt)
	self.cardSlot5:update(dt)
	self.cardSlot6:update(dt)
	self.cardSlot7:update(dt)
end
function HolderLocations:drawAll()
	self.drawPile:draw()
	self.drawnPile:draw()
	self.aceSlot1:draw()
	self.aceSlot2:draw()
	self.aceSlot3:draw()
	self.aceSlot4:draw()
	self.cardSlot1:draw()
	self.cardSlot2:draw()
	self.cardSlot3:draw()
	self.cardSlot4:draw()
	self.cardSlot5:draw()
	self.cardSlot6:draw()
	self.cardSlot7:draw()
end
