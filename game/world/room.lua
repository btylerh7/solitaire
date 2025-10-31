local class = require("engine.object-v2")

---@class Room
---@field box Box
---@field player
---@field entities any []
---@field tiles any[]
---@field doors any[]
local Room = class.new("Room")

return Room
