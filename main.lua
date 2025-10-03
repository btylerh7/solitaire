require("card")
require("card-holder")
require("holder-locations")
require("all-cards")

G = {}
G.cardWidth = 48
G.cardHeight = 64

function love.load()
	HolderLocations:setup()
	AllCards:loadCards()
	HolderLocations.cardSlot1:addCard(AllCards[1])
	HolderLocations.cardSlot1:addCard(AllCards[2])
	HolderLocations.cardSlot1:addCard(AllCards[3])
	HolderLocations.cardSlot2:addCard(AllCards[4])
	HolderLocations.cardSlot2:addCard(AllCards[5])
	HolderLocations.cardSlot2:addCard(AllCards[6])
end

function love.update(dt)
	HolderLocations:updateAll(dt)
end

function love.draw()
	love.graphics.setBackgroundColor(0.21, 0.42, 0.16)
	HolderLocations:drawAll()
end
