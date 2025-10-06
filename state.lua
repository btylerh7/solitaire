---@class CurrentlyMoving
---@field holder Holder | nil
---@field targetHolder Holder | nil
---@field cards Card[]
CurrentlyMoving = {
	holder = nil,
	targetHolder = nil,
	cards = {},
}
CurrentlyMoving.__index = CurrentlyMoving

---@class State
---@field currentlyMoving CurrentlyMoving
---@field pressed boolean
---@field isMoving boolean
State = {}
State.__index = State

function State.setup()
	local state = setmetatable({}, State)
	state.pressed = false
	state.isMoving = false
	state.currentlyMoving = {
		holder = nil,
		targetHolder = nil,
		cards = {},
	}
	return state
end

---@param holder Holder
---@param clickedCard Card
--- Removes clicked card and rest of cards from holder and puts in currentlyMoving
function State:setMoving(holder, clickedCard)
	self.isMoving = true
	local toRemove = {}
	local found = false
	self.currentlyMoving.holder = holder
	for index, card in ipairs(holder.cards) do
		if clickedCard.rank == card.rank and clickedCard.suit == card.suit then
			found = true
		end
		if found == true then
			table.insert(self.currentlyMoving.cards, card)
			table.insert(toRemove, index)
			-- TODO maybe add index optional to not have to do loops to remove it?
		end
	end
	for _, value in ipairs(toRemove) do
		table.remove(holder.cards, value)
	end
end

function State:draw()
	if self.pressed == true and self.isMoving == true and (self.currentlyMoving.cards == nil) == false then
		for index, card in ipairs(self.currentlyMoving.cards) do
			card:draw()
		end
	end
end

---@param holder Holder
--- Add a target once user lets go of mouse
function State:setTargetHolder(holder)
	self.currentlyMoving.targetHolder = holder
end

function State:moveCard(x, y)
	local hasCards = #self.currentlyMoving.cards > 0
	if hasCards == true and self.isMoving == true and self.pressed == true then
		for index, card in ipairs(self.currentlyMoving.cards) do
			local yOffset = 20 * (index - 1)
			card.x = x
			card.y = y + yOffset
		end
	end
end

---@param shouldMove boolean
--- Moves cards from currently moving to selected holder
function State:transferCards(shouldMove)
	for _, card in ipairs(self.currentlyMoving.cards) do
		if shouldMove == true then
			self.currentlyMoving.targetHolder:addCard(card)
		else
			self.currentlyMoving.holder:addCard(card)
		end
	end
end

function State:mousereleased(x, y)
	if #self.currentlyMoving.cards > 0 then
		local firstCard = self.currentlyMoving.cards[1]
		for index, holder in ipairs(HolderLocations.cardSlots) do
			if holder:isInHolder(x, y) == true then
				self:setTargetHolder(holder)
				self:transferCards(true)
				break
			end
		end
		-- self.currentlyMoving.cards[1]:mousereleased(x, y)
	end
	self.isMoving = false
	self.pressed = false
	self.currentlyMoving = {
		holder = nil,
		targetHolder = nil,
		cards = {},
	}
	-- self.currentlyMoving.cards.cards[1]:mousereleased(x, y, )
end
