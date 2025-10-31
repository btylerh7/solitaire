local class = require("engine.object-v2")
local Animation = require("engine.animation")
local anim8 = require("vendor.anim8")

---@class Player
---@field anim Animation
---@field spriteSheet love.Image
local Player = class.new("Player")

function Player:new(x, y)
	local player = setmetatable({}, self)
	player.spriteSheet = love.graphics.newImage("assets/Solitaire-Player.png")
	player.grid = anim8.newGrid(32, 32, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
	player.animations = {}
	player.animations.horizontal = anim8.newAnimation()
	return player
end

function Player:update(dt)
	local _ = dt --just to stop the lsp warning
	if love.keyboard.isDown("right") then
		self.anim.isAnimating = true
		self.anim.box.x = self.anim.box.x + 10
	elseif love.keyboard.isDown("left") then
		self.anim.box.x = self.anim.box.x - 10
		self.isAnimating = true
	else
		self.isAnimating = false
	end
	self.anim:update(dt)
end

function Player:draw()
	self.anim:draw()
end

return Player
