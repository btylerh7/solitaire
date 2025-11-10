local Button = require("game.ui.button")
local class = require("engine.class")

---@class PlayButton: Button
local PlayButton = class.inherit(Button, "PlayButton")

---@param box Box
---@param opts {color: number[], borderRadius: number, onClick: fun()}
function PlayButton:new(box, opts)
	local text = "Play Game"
	local button = Button:new(box, text, opts)
	button.box = box
	button.text = text
	button.opts = opts
	button:centerXY()
	button.onClick = function()
		ScreenState:changeScreen(ScreenState.screens.SOLITAIRE)
	end
	return button
end

return PlayButton
