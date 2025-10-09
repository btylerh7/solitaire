require("card")
require("holder")
require("holder-game")
require("holder-ace")
require("holder-draw")
require("holder-locations")
require("all-cards")
require("state")

G = {}
G.cardWidth = 48
G.cardHeight = 64
G.zoomMultiplier = 2
State = State:new()

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
	State:draw()
end

function love.mousepressed(x, y, button, isTouched)
	if button == 1 then
		State.pressed = true
		State:checkDoubleClick()
		HolderLocations:mousepressed(x, y)
	end
end
function love.mousemoved(x, y)
	State:moveCard(x, y)
end
function love.mousereleased(x, y, button)
	if button == 1 then
		State.pressed = false
		State:mousereleased(x, y)
	end
end
