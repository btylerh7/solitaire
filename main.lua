require("card")

function love.load()
	createCards()
end

function love.update(dt)
	Card:updateAll(dt)
end

function love.draw()
	Card:drawAll()
end

function createCardGroup(count, startingX, startingY, stepCount)
	local currentX = startingX

	for _ = 1, count, 1 do
		Card.new(currentX, startingY)
		currentX = currentX + stepCount
	end
end
function createCards()
	createCardGroup(7, 50, 250, 125)
	createCardGroup(4, love.graphics.getWidth() / 2, 15, 125)
	createCardGroup(1, 50, 15, 125)
end
