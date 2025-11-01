local G = {}
G.cardWidth = 48 * 2
G.cardHeight = 64 * 2
G.gameHolderYStep = 20
G.zoomMultiplier = 1
G.shaders = {}
G.shaders.hearts = love.graphics.newShader("assets/shaders/heart-shader.glsl")
G.shaders.outline = love.graphics.newShader("assets/shaders/outline.glsl")
G.cardSprite = love.graphics.newImage("assets/cards/cards-v2.png")
G.uiFont = love.graphics.newFont("assets/fonts/TerminessNerdFontMono-Regular.ttf", 45, "normal")
G.buttonFont = love.graphics.newFont("assets/fonts/TerminessNerdFontMono-Regular.ttf", 49, "normal")
G.sounds = {}
G.sounds.cardClick = love.audio.newSource("assets/audio/card-click.ogg", "static")

return G
