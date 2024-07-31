local PATH = (...):gsub("%.[^%.]+$", "")
local Class = require(PATH .. "Class")
local Constants = require(PATH .. "Constants")

local Value = Class()

local VOID    = Constants.TYPE_VOID
local STRING  = Constants.TYPE_STRING
local NUMBER  = Constants.TYPE_NUMBER
local BOOLEAN = Constants.TYPE_BOOLEAN
local DIVERT  = Constants.TYPE_DIVERT
local POINTER = Constants.TYPE_POINTER
local LIST    = Constants.TYPE_LIST

local TYPES = {
    VOID,
    STRING,
    NUMBER,
    BOOLEAN,
    DIVERT,
    POINTER,
    LIST
}

local CASTS = {}
for _, valueType in ipairs(TYPES) do
    CASTS[valueType] = {}
end

-- Cast from strings
CASTS[STRING][NUMBER] = function(value)
    return tonumber(value)
end

CASTS[STRING][BOOLEAN] = function(value)
    return #value > 0
end

CASTS[STRING][DIVERT] = function(value)
    return value
end

-- Cast from numbers
CASTS[NUMBER][STRING] = function(value)
    return tostring(value)
end

CASTS[NUMBER][BOOLEAN] = function(value)
    return value ~= 0
end

-- Cast from booleans
CASTS[BOOLEAN][STRING] = function(value)
    return value and "true" or "false"
end

CASTS[BOOLEAN][NUMBER] = function(value)
    return value and 1 or 0
end

-- Cast from divert
CASTS[DIVERT][STRING] = function(value)
    return value
end

-- Cast from lists
CASTS[LIST][BOOLEAN] = function(value)
    return next(value) ~= nil
end

CASTS[LIST][NUMBER] = function(value)
    local maxItem = value:getMax()
    if not maxItem then
        return 0
    end

    return maxItem.value
end

CASTS[LIST][STRING] = function(value)
    local maxItem = value:getMax()
    if not maxItem then
        return ""
    end

    return maxItem.key or ""
end

function Value:new(valueType, value, object)
    self._type = valueType
    self._value = value
    self._object = object
end

function Value:getCurrentValue()
    return self._value
end

function Value:getType()
    return self._type
end

function Value:getObject()
    return self._object
end

function Value:getField(field)
    if type(self._object) == "table" then
        return self._object[field]
    end

    return nil
end

function Value:cast(valueType)
    if self._type == valueType then
        return self._value
    end

    local func = CASTS[self._type] and CASTS[self._type][valueType]
    if func then
        return func(self._value)
    end

    return nil
end

function Value:copy(other)
    if other then
        other._type = self._type
        other._value = self._value
        other._object = self._object
    else
        other = Value(self._type, self._value, self._object)
    end

    return other
end

return Value
