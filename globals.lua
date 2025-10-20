local G = {}
G.cardWidth = 48 * 2
G.cardHeight = 64 * 2
G.gameHolderYStep = 20
G.zoomMultiplier = 1
G.shaders = {}
G.shaders.outline = love.graphics.newShader("shaders/outline.glsl")
G.cardSprite = love.graphics.newImage("cards/cards-v2.png")
G.uiFont = love.graphics.newFont("fonts/TerminessNerdFontMono-Regular.ttf", 69, "normal")

return G
