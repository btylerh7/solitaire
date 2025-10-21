local Klondike = require("game.rules.klondike")
local Freecell = require("game.rules.freecell")
return {
	KLONDIKE = Klondike:new(),
	FREECELL = Freecell:new(),
}
