require("card")
require("card-holder")
require("holder-locations")
require("all-cards")

G = {}
G.cardWidth = 48
G.cardHeight = 64
State = {
	pressed = false,
}

function love.load()
	HolderLocations:setup()
	AllCards:loadCards()
	AllCards:shuffle()
	HolderLocations:addShuffledCards(AllCardsShuffled)
end

function love.update(dt)
	HolderLocations:updateAll(dt)
end

function love.draw()
	love.graphics.setBackgroundColor(0.21, 0.42, 0.16)
	HolderLocations:drawAll()
end

function love.mousepressed(x, y, button, isTouched)
	if button == 1 then
		State.pressed = true
		HolderLocations:mousepressed(x, y)
	end
end
function love.mousemoved(x, y)
	if State.pressed == true then
		HolderLocations:mousemoved(x, y)
	end
end
function love.mousereleased(x, y, button)
	if button == 1 then
		State.pressed = false
		HolderLocations:mousereleased(x, y)
	end
end
