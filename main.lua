require("card")
require("card-holder")
require("holder-locations")

G = {}
G.cardWidth = 48
G.cardHeight = 64

function love.load()
	HolderLocations:setup()
end

function love.update(dt)
	HolderLocations:updateAll(dt)
end

function love.draw()
	love.graphics.setBackgroundColor(0.21, 0.42, 0.16)
	HolderLocations:drawAll()
end
