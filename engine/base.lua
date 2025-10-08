---@class Base
Base = {}
Base.__index = Base
function Base:init() end

function Base:extend()
	local class = {}
	for key, value in pairs(self) do
		if key:find("__") == 1 then
			class[key] = value
		end
	end
	class.__index = class
	class.super = self
	setmetatable(class, self)
	return class
end

function Base:is(T)
	local mt = getmetatable(self)
	while mt do
		if mt == T then
			return true
		end
		mt = getmetatable(mt)
	end
	return false
end

function Base:__tostring()
	return "Base"
end

function Base:__call(...)
	local base = setmetatable({}, self)
	base:init(...)
	return base
end
