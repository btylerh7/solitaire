local G = {}
G.cardWidth = 48 * 2
G.cardHeight = 64 * 2
G.gameHolderYStep = 20
G.zoomMultiplier = 1
G.shaders = {}
G.shaders.outline = love.graphics.newShader("shaders/outline.glsl")

return G
