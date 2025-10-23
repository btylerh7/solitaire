local class = require("engine.object-v2")
local Card = require("game.entities.card")
local GameHolder = require("game.entities.holders.holder-game")
local AceHolder = require("game.entities.holders.holder-ace")
local DrawHolder = require("game.entities.holders.holder-draw")

---@class Rule
---@field tableauColumns number
---@field foundationColumns number
---@field useStock boolean -- Games like Freecell will not use a draw pile
---@field wasteColumns number -- Most games use one, but games like Freecell can use this for the four "Free cells"
---@field deal fun(self): {foundation: Foundation[], tableau: Tableau[], stock: Stock, waste: Stock[]}
local Rule = class.new("Rule")

---@param opts {tableauColumns: number, foundationColumns: number, useStock: boolean, wasteColumns: number}
function Rule:new(opts)
	local rule = setmetatable({}, self)
	rule.tableauColumns = opts.tableauColumns
	rule.foundationColumns = opts.foundationColumns
	rule.useStock = opts.useStock
	rule.wasteColumns = opts.wasteColumns
	return rule
end

function Rule:deal()
	return { {}, {}, {}, {} }
end

function Rule:isOppositeSuit(suit1, suit2)
	if suit1 == 1 or suit1 == 2 then
		return suit2 == 3 or suit2 == 4
	else
		return suit2 == 1 or suit2 == 2
	end
end

function Rule:isOneLess(cardRank, holderCardRank)
	return cardRank == holderCardRank - 1
end
function Rule:isOneMore(cardRank, holderCardRank)
	return cardRank == holderCardRank + 1
end

return Rule
