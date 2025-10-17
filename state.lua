require("functions.shuffle")

local States = {}

States.gameLocation = {
	isMenu = false,
	isGame = true,
	isPaused = false,
}
---@class States.gameState
---@field activeCards Card[]
---@field clicked boolean
---@field moving boolean: Whether the user is moving cards at the moment
---@field movingCards {cards: Card[], targetHolder?: Holder, startingHolder?: Holder}
---@field draw fun(self)
---@field remainingRedraws number
---@field isWin boolean
---@field new fun(self)
---@field reset fun(self)
States.gameState = {}

function States.gameState:new()
	self:reset()
	self.activeCards = setUpCards()
	self.remainingRedraws = 3
	self.isWin = false
end
function States.gameState:reset()
	self.clicked = false
	self.moving = false
	self.movingCards = {
		cards = {},
		targetHolder = nil,
		startingHolder = nil,
	}
end

function States.gameState:draw()
	if self.moving then
		for i, card in ipairs(self.movingCards.cards) do
			card:draw()
		end
	end
end

return States
