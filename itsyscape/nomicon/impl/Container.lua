local PATH = (...):gsub("%.[^%.]+$", "")

---@as nomicon.impl.enums
local enums = require(PATH .. "impl.enums")

--- @class nomicon.impl.container
local container = {}
container.__index = container

--- @param c table
--- @return nomicon.impl.container
function container.new(c)
    local result = setmetatable({}, container)

    
end