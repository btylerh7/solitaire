local class = require("engine.class")

---@class EventHandler
local EventHandler = class.new("EventHandler")

function EventHandler:new()
	local handler = setmetatable({}, self)
	return handler
end

---@param mouseX number
---@param mouseY number
function EventHandler:doubleClicked(mouseX, mouseY)
	local _ = mouseX
	local _ = mouseY
	error("Must be implemented by subclass")
end

---@param mouseX number
---@param mouseY number
function EventHandler:checkClickType(mouseX, mouseY)
	if ScreenState.currentScreen == ScreenState.screens.SOLITAIRE and States.gameState.gameRules.useStock then
		if HolderLocations.drawPile:checkInHolder(mouseX, mouseY) then
			--No need to check double click
			self:handleClick(mouseX, mouseY)
			return
		end
	end
	local currentTime = love.timer.getTime()
	local timer = States.clickTimer

	local timeBetweenClicks = currentTime - timer.clickTime

	if timeBetweenClicks < timer.clickInterval then
		-- second click within clicking interval... double click
		timer.singleClickPending = false
		self:doubleClicked(mouseX, mouseY)
	else
		-- could be single click
		print("could be single click")
		timer.clickTime = currentTime
		timer.clickX = mouseX
		timer.clickY = mouseY
		timer.singleClickPending = true
	end
end

---@param mouseX number
---@param mouseY number
function EventHandler:handleClick(mouseX, mouseY)
	local _ = mouseX
	local _ = mouseY
	error("Must be implemented by subclass")
end

---@param mouseX number
---@param mouseY number
function EventHandler:mouseReleased(mouseX, mouseY)
	local _ = mouseX
	local _ = mouseY
	error("Must be implemented by subclass")
end

return EventHandler
