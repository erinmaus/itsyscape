local PATH = (...):gsub("%.[^%.]+$", "")
local Class = require(PATH .. "Class")
local Constants = require(PATH .. "Constants")
local List = require(PATH .. "List")
local Pointer = require(PATH .. "Pointer")

local Value = Class()

local VOID    = Constants.TYPE_VOID
local STRING  = Constants.TYPE_STRING
local NUMBER  = Constants.TYPE_NUMBER
local BOOLEAN = Constants.TYPE_BOOLEAN
local DIVERT  = Constants.TYPE_DIVERT
local POINTER = Constants.TYPE_POINTER
local LIST    = Constants.TYPE_LIST
local GLUE    = Constants.TYPE_GLUE
local TAG     = Constants.TYPE_TAG

local TYPES = {
    VOID,
    STRING,
    NUMBER,
    BOOLEAN,
    DIVERT,
    POINTER,
    LIST,
    GLUE,
    TAG
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
    local maxValue = value:getMaxValue()
    if not maxValue then
        return 0
    end

    return maxValue:getValue()
end

CASTS[LIST][STRING] = function(value)
    local maxItem = value:getMaxValue()
    if not maxItem then
        return ""
    end

    return maxItem:getValueName()
end

-- Cast from glue
CASTS[GLUE][STRING] = function(_value)
    return "\0"
end

-- Cast from tag
CASTS[TAG][STRING] = function(value)
    return value
end

function Value:new(valueType, value, object)
    if valueType == nil then
        self:_fromValue(value, object)
    else
        self:_init(valueType, value, object)
    end
end

function Value:_init(valueType, value, object)
    self._type = valueType
    self._value = value
    self._object = object
end

function Value:_fromValue(value, object)
    local valueClassType = Class.getType(value)
    if valueClassType ~= nil then
        if Class.isClass(valueClassType, Value) then
            self:_init(value:getType(), value:getValue(), value:getObject())
        elseif Class.isClass(valueClassType, List) then
            self:_init(LIST, value, object)
        elseif Class.isClass(valueClassType, Pointer) then
            self:_init(POINTER, value, object or value:getObject())
        else
            error(string.format("unhandled Class-based value '%s'", valueClassType._DEBUG and valueClassType._DEBUG.shortName or "???"))
        end
    else
        local valueType = type(value)
        if valueType == "boolean" then
            self:_init(BOOLEAN, value, object)
        elseif valueType == "string" then
            if object == Constants.VALUE_GLUE then
                self:_init(GLUE, value, object)
            elseif object == "void" then
                self:_init(VOID, value, object)
            elseif type(object) == "string" and object:sub(1, 1) == "^" then
                self:_init(STRING, value:sub(2), object)
            else
                self:_init(STRING, value, object)
            end
        elseif valueType == "number" then
            self:_init(NUMBER, value, object)
        elseif object and valueType == "table" then
            if object and object[Constants.FIELD_DIVERT_TARGET] then
                self:_init(DIVERT, object[Constants.FIELD_DIVERT_TARGET], object)
            elseif object and object[Constants.FIELD_VARIABLE_POINTER] then
                self:_init(POINTER, Pointer(object), object)
            end
        else
            error(string.format("unsupported value with Lua type '%s'", value))
        end
    end
end

function Value:getValue()
    return self._value
end

function Value:is(valueType)
    return self._type == valueType
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

function Value.isValue(instruction)
    if type(instruction) == "string" then
        return instruction:sub(1, 1) == "^" or instruction == "\n" or instruction == Constants.VALUE_GLUE or instruction == "void"
    elseif type(instruction) == "number" or type(instruction) == "boolean" then
        return true
    elseif type(instruction) == "table" then
        if instruction and instruction[Constants.FIELD_DIVERT_TARGET] then
            return true
        elseif instruction and instruction[Constants.FIELD_VARIABLE_POINTER] then
            return true
        end
    end

    return false
end

function Value:call(executor)
    executor:getEvaluationStack():push(self)
end

Value.VOID = Value(VOID, nil, "void")

return Value
