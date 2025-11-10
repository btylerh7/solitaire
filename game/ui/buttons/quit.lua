local Button = require("game.ui.button")
local class = require("engine.class")

---@class QuitButton: Button
local QuitButton = class.inherit(Button, "ExitButton")

---@param box Box
---@param opts {color: number[], borderRadius: number, onClick: fun()}
function QuitButton:new(box, opts)
	local text = "Quit Game"
	local button = Button:new(box, text, opts)
	button.box = box
	button.text = text
	button.opts = opts
	button:centerXY()
	button.onClick = function()
		print("Changing to menu")
		ScreenState:changeScreen(ScreenState.screens.MENU)
	end
	return button
end

return QuitButton
