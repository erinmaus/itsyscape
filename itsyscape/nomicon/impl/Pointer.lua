local PATH = (...):gsub("%.[^%.]+$", "")
local Class = require(PATH .. "Class")
local Constants = require(PATH .. "Constants")

local Pointer = Class()

function Pointer:new(object)
    self._variable = object[Constants.FIELD_VARIABLE_POINTER]
    self._contextIndex = object[Constants.FIELD_CONTEXT_INDEX] or -1
    self._object = object
end

function Pointer:getContextIndex()
    return self._contextIndex
end

function Pointer:updateContextIndex(value, other)
    other = self:copy(other)
    other._contextIndex = value

    return other
end

function Pointer:getObject()
    return self._object
end

function Pointer:copy(other)
    if other then
        other._variable = self._variable
        other._object = self._object
    else
        other = Pointer(self._object)
    end

    other._contextIndex = self._contextIndex

    return other
end

return Pointer
