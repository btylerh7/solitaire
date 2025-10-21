require("functions.shuffle")
local Klondike = require("game.rules.klondike")
local Rule = require("game.rules.rule")

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
---@field isBoardSet boolean
---@field gameRules Rule | Klondike
---@field new fun(self)
---@field reset fun(self)
States.gameState = {}

---@class States.clickTimer
--- used for tracking double click
---@field clickTime number
---@field clickInterval number
---@field singleClickPending boolean
---@field clickX number
---@field clickY number
States.clickTimer = {}

function States:reset()
	self.gameState:reset()
	self.clickTimer:reset()
end

function States:new()
	States.clickTimer:new()
	States.gameState:new()
end
function States.clickTimer:new()
	self:reset()
	self.clickInterval = 0.15
end
function States.clickTimer:reset()
	self.clickTime = love.timer.getTime()
	self.singleClickPending = false
	self.clickX = 0
	self.clickY = 0
end
function States.gameState:new()
	self:reset()
	self.gameRules = Klondike:new()
	self.isBoardSet = false
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
		forEach(self.movingCards.cards, function(card)
			card:draw()
		end)
	end
end

---@param holder Holder
function States:setStartingHolder(holder)
	self.gameState.movingCards.startingHolder = holder
end

function States.gameState:checkIsWin()
	if self.isBoardSet then
		local isWin = true
		forEach(HolderLocations.aceSlots, function(aceHolder)
			if isWin then
				local isFull = #aceHolder.cards == 13
				if not isFull then
					isWin = false
				end
			end
		end)
		self.isWin = isWin
	end
end

return States
