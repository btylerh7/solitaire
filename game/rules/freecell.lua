local Rule = require("game.rules.rule")
local class = require("engine.object-v2")

---@class Freecell:Rule
local Freecell = class.inherit(Rule, "Freecell")

---@return Freecell
function Freecell:new()
	local rule = Rule:new({
		tableauColumns = 8,
		foundationColumns = 4,
		wasteColumns = 4,
		useStock = false,
	})
	return rule
end

return Freecell
