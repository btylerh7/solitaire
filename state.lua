---@class CurrentlyMoving
---@field holder Holder | nil
---@field targetHolder Holder | nil
---@field cards Holder | nil
CurrentlyMoving = {
	holder = nil,
	targetHolder = nil,
	cards = nil,
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
		cards = nil,
	}
	return state
end

---@param holder Holder
---@param clickedCard Card
--- Removes clicked card and rest of cards from holder and puts in currentlyMoving
function State:setMoving(holder, clickedCard)
	self.isMoving = true
	self.currentlyMoving.cards = Holder.new(clickedCard.x, clickedCard.y, "game")
	local found = false
	self.currentlyMoving.holder = holder
	for index, card in ipairs(holder.cards) do
		if found == true then
			self.currentlyMoving.cards:addCard(card)
			-- TODO maybe add index optional to not have to do loops to remove it?
			holder:removeCard(card)
		else
			if clickedCard.rank == card.rank and clickedCard.suit == card.suit then
				found = true
				self.currentlyMoving.cards:addCard(card)
				holder:removeCard(card)
			end
		end
	end
end

function State:draw()
	if self.pressed == true and self.isMoving and not self.currentlyMoving.cards == nil then
		self.currentlyMoving.cards:draw()
	end
end

---@param holder Holder
--- Add a target once user lets go of mouse
function State:setTargetHolder(holder)
	self.currentlyMoving.targetHolder = holder
end

function State:moveCard(x, y)
	if self.currentlyMoving.cards[1] and self.currentlyMoving.cards[1].isMoving == true then
		self.currentlyMoving.cards[1]:mousemoved(x, y)
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
	self.isMoving = false
	self.pressed = false
	self.currentlyMoving = {
		holder = nil,
		targetHolder = nil,
		cards = nil,
	}
	-- self.currentlyMoving.cards.cards[1]:mousereleased(x, y, )
end
