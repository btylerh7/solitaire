Events = {}

function Events:clicked(mouseX, mouseY)
	print("Checking click at " .. mouseX .. " " .. mouseY)
	for index, card in ipairs(States.gameState.activeCards) do
		local isClicked = card:checkIsClicked(mouseX, mouseY)
		local isDisplayed = card.isDisplayed
		local hasParent = card.parent ~= nil
		if isClicked and isDisplayed and hasParent then
			print("found card")
			card.isMoving = true
			card.isClicked = true
			States.gameState.moving = true
			local moving = false
			for _, holderCard in ipairs(card.parent.cards) do
				if moving then
					table.insert(States.gameState.movingCards.cards, holderCard)
				elseif holderCard.isMoving then
					table.insert(States.gameState.movingCards.cards, holderCard)
					moving = true
				end
			end
			return
		end
	end
end

---@param card Card
---@param mouseX number
---@param mouseY number
function Events:cardDragged(card, mouseX, mouseY) end

function Events:cardMoving(mouseX, mouseY) end

function Events:mouseReleased(mouseX, mouseY) end
