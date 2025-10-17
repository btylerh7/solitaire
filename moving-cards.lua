---@class MovingCardHolder: Holder
MovingCardHolder = Holder:extend()

function MovingCardHolder:new()
	---@class MovingCardHolder:Holder
	local holder = setmetatable({}, self)
	holder.x = 0
	holder.y = 0
	holder.width = G.cardWidth
	holder.height = G.cardHeight
	holder.cards = {}
	holder.type = ""
	holder.nextRank = nil
	holder.nextSuit = {}
	return holder
end

function MovingCardHolder:setCardLocation()
	local yStep = G.gameHolderYStep
	if #self.cards == 0 then
		self.lowestSuit = nil
		self.lowestRank = nil
	end
	for index, card in ipairs(self.cards) do
		local currentYStep = (index - 1) * yStep
		card.x = self.x
		card.y = self.y + currentYStep
		if index == #self.cards then
			card.isInStack = false
			self.lowestRank = card.rank
			self.lowestSuit = card.suit
		else
			card.isInStack = true
		end
	end
end
function MovingCardHolder:moveToMouse(x, y)
	self.x = x
	self.y = y
	self:setCardLocation()
end

---@param card Card
---@param target Holder
---@param current Holder
function MovingCardHolder:transferCard(card, target, current)
	if target:checkCanAdd(card.rank, card.suit) then
		local currentIndex = current:getIndexOfCard(card)
		if currentIndex then
			target:addCard(card)
			current:removeCard(currentIndex)
		end
	else
		current:addCard(card)
	end
end

function MovingCardHolder:draw()
	if #self.cards == 0 then
		return
	end
	for _, card in ipairs(self.cards) do
		card:draw()
	end
end
