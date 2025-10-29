-- Reference https://github.com/Mordoria/unnamed_game_1_v2/blob/master/vendor/object.lua --
local M = {}

---Create new class
---@param class_type string
---@return table
function M.new(class_type)
	local object = {}
	object.__index = object
	object._type = class_type
	return object
end

--- Inherit from a parent class
---@generic T
---@param parent T
---@return { super: T}
function M.inherit(parent, type)
	local child = { super = parent }
	child.__index = child
	child._type = type
	return setmetatable(child, { __index = parent })
end
return M
