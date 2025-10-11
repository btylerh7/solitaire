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
---@field lastClick number - number of clicks within interval
---@field clickInterval number - number of seconds between clicks
---@field isMoving boolean
---@field remainingRedraws number - number of times the draw pile can be reset
---@field doubleClick boolean
State = {}
State.__index = State

function State.new()
	local state = setmetatable({}, State)
	state:setup()
	return state
end
function State:setup()
	self.pressed = false
	self.isMoving = false
	self.clickInterval = 0.2
	self.lastClick = 0
	self.currentlyMoving = {
		holder = nil,
		targetHolder = nil,
		cards = {},
	}
	self.remainingRedraws = 3
end

---@param holder Holder
---@param clickedCard Card
--- Removes clicked card and rest of cards from holder and puts in currentlyMoving
function State:setMoving(holder, clickedCard)
	self.isMoving = true
	local toRemove = 0
	local toRemoveStartIndex = 0
	local found = false
	self.currentlyMoving.holder = holder
	for index, card in ipairs(holder.cards) do
		if clickedCard.rank == card.rank and clickedCard.suit == card.suit then
			toRemoveStartIndex = index
			found = true
		end
		if found == true then
			table.insert(self.currentlyMoving.cards, card)
			toRemove = toRemove + 1
			-- TODO maybe add index optional to not have to do loops to remove it?
		end
	end
	while toRemove > 0 do
		holder:removeCard(toRemoveStartIndex)
		toRemove = toRemove - 1
	end
	holder:setCardLocation()
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
			self.currentlyMoving.holder:checkShouldReveal()
		else
			self.currentlyMoving.holder:addCard(card)
		end
	end
end

---@param card Card
--- Add to ace slot if available
function State:checkAceSlots(card)
	for _, holder in ipairs(HolderLocations.aceSlots) do
		local canAdd = holder:checkCanAdd(card.rank, card.suit)
		if canAdd == true then
			print("Adding to ace holder")
			print(card.rank)
			print(card.suit)
			self:setTargetHolder(holder)
			self:transferCards(canAdd)
		end
		self.doubleClick = false
		return
	end
end
function State:mousereleased(x, y)
	local holderType = HolderLocations:getHolderType(x, y)

	if #self.currentlyMoving.cards > 0 then
		local inHolder = false
		if holderType == HolderType.ACE then
			for _, holder in ipairs(HolderLocations.aceSlots) do
				if holder:isInHolder(x, y) then
					inHolder = true
					self:setTargetHolder(holder)
					local currentCard = self.currentlyMoving.cards[1]
					local shouldMove = holder:checkCanAdd(currentCard.rank, currentCard.suit)
					self:transferCards(shouldMove)
				end
			end
		end
		for _, holder in ipairs(HolderLocations.cardSlots) do
			if holder:isInHolder(x, y) == true then
				inHolder = true
				self:setTargetHolder(holder)
				local currentCard = self.currentlyMoving.cards[1]
				if self.doubleClick and #self.currentlyMoving.cards == 1 then
					print("checking ace slots")
					self:checkAceSlots(currentCard)
				end
				if not self.doubleClick then
					local shouldMove = holder:checkCanAdd(currentCard.rank, currentCard.suit)
					self:transferCards(shouldMove)
				end
				break
			end
		end
		if inHolder == false then
			self:transferCards(false)
		end
	end
	self:setup()
end
