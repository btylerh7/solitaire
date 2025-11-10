local Button = require("game.ui.button")
local class = require("engine.class")

---@class ExitButton: Button
local ExitButton = class.inherit(Button, "ExitButton")

---@param box Box
---@param opts {color: number[], borderRadius: number, onClick: fun()}
function ExitButton:new(box, opts)
	local text = "Exit Game"
	local button = Button:new(box, text, opts)
	button.box = box
	button.text = text
	button.opts = opts
	button:centerXY()
	button.onClick = function()
		love.event.quit()
	end
	return button
end

return ExitButton
