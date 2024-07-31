local PATH = (...):gsub("%.[^%.]+$", "")
local Class = require(PATH .. "Class")

local Command = Class()

function Command:new(parent, container)
    self._parent = parent
    self._container = container
end

function Command:getContainer()
    return self._container
end

function Command:getParent()
    return self._parent
end

function Command:getIsRoot()
    return self._parent == nil
end

return Command