local PATH = (...):gsub("%.[^%.]+$", "")
local Class = require(PATH .. "Class")
local Constants = require(PATH .. "Constants")

local NativeFunction = Class()

local VOID    = Constants.TYPE_VOID
local STRING  = Constants.TYPE_STRING
local NUMBER  = Constants.TYPE_NUMBER
local BOOLEAN = Constants.TYPE_BOOLEAN
local DIVERT  = Constants.TYPE_DIVERT
local POINTER = Constants.TYPE_POINTER
local LIST    = Constants.TYPE_LIST
local GLUE    = Constants.TYPE_GLUE

local ADD                   = Constants.NATIVE_FUNCTION_ADD
local SUBTRACT              = Constants.NATIVE_FUNCTION_SUBTRACT
local DIVIDE                = Constants.NATIVE_FUNCTION_DIVIDE
local MULTIPLY              = Constants.NATIVE_FUNCTION_MULTIPLY
local MODULO                = Constants.NATIVE_FUNCTION_MODULO
local UNARY_NEGATE          = Constants.NATIVE_FUNCTION_UNARY_NEGATE
local EQUAL                 = Constants.NATIVE_FUNCTION_EQUAL
local LESS                  = Constants.NATIVE_FUNCTION_LESS
local GREATER               = Constants.NATIVE_FUNCTION_GREATER
local LESS_THAN_OR_EQUAL    = Constants.NATIVE_FUNCTION_LESS_THAN_OR_EQUAL
local GREATER_THAN_OR_EQUAL = Constants.NATIVE_FUNCTION_GREATER_THAN_OR_EQUAL
local NOT_EQUAL             = Constants.NATIVE_FUNCTION_NOT_EQUAL
local UNARY_NOT             = Constants.NATIVE_FUNCTION_UNARY_NOT
local LOGICAL_AND           = Constants.NATIVE_FUNCTION_LOGICAL_AND
local LOGICAL_OR            = Constants.NATIVE_FUNCTION_LOGICAL_OR
local MIN                   = Constants.NATIVE_FUNCTION_MIN
local MAX                   = Constants.NATIVE_FUNCTION_MAX
local POW                   = Constants.NATIVE_FUNCTION_POW
local FLOOR                 = Constants.NATIVE_FUNCTION_FLOOR
local CEILING               = Constants.NATIVE_FUNCTION_CEILING
local INT                   = Constants.NATIVE_FUNCTION_INT
local FLOAT                 = Constants.NATIVE_FUNCTION_FLOAT
local INCLUDE               = Constants.NATIVE_FUNCTION_INCLUDE
local DOES_NOT_INCLUDE      = Constants.NATIVE_FUNCTION_DOES_NOT_INCLUDE
local INTERSECT             = Constants.NATIVE_FUNCTION_INTERSECT
local LIST_MIN              = Constants.NATIVE_FUNCTION_LIST_MIN
local LIST_MAX              = Constants.NATIVE_FUNCTION_LIST_MAX
local LIST_ALL              = Constants.NATIVE_FUNCTION_LIST_ALL
local LIST_COUNT            = Constants.NATIVE_FUNCTION_LIST_COUNT
local LIST_VALUE            = Constants.NATIVE_FUNCTION_LIST_VALUE
local LIST_INVERT           = Constants.NATIVE_FUNCTION_LIST_INVERT

local PERFORM = {
    [ADD] = function(coercedType, leftValue, rightValue)
        if coercedType == LIST then
            if rightValue:getType() == LIST then
                return leftValue:getValue():add(rightValue:getValue())
            elseif rightValue:getType() == NUMBER then
                return leftValue:getValue():increment(rightValue:cast(NUMBER))
            end
        elseif coercedType == STRING then
            local a = leftValue:cast(STRING)
            local b = rightValue:cast(STRING)

            if a ~= nil and b ~= nil then
                return a .. b
            end
        elseif coercedType == NUMBER then
            local a = leftValue:cast(coercedType)
            local b = rightValue:cast(coercedType)

            if a ~= nil and b ~= nil then
                return a + b
            end
        end

        return nil
    end,

    [SUBTRACT] = function(coercedType, leftValue, rightValue)
        if coercedType == LIST then
            if rightValue:getType() == LIST then
                return leftValue:getValue():remove(rightValue:getValue())
            elseif rightValue:getType() == NUMBER then
                return leftValue:getValue():decrement(rightValue:cast(NUMBER))
            end
        elseif coercedType == NUMBER then
            local a = leftValue:cast(coercedType)
            local b = rightValue:cast(coercedType)

            if a ~= nil and b ~= nil then
                return a - b
            end
        end

        return nil
    end,

    [DIVIDE] = function(coercedType, leftValue, rightValue)
        if coercedType == NUMBER then
            local a = leftValue:cast(coercedType)
            local b = rightValue:cast(coercedType)

            if a ~= nil and b ~= nil then
                return a / b
            end
        end

        return nil
    end,

    [MULTIPLY] = function(coercedType, leftValue, rightValue)
        if coercedType == NUMBER then
            local a = leftValue:cast(coercedType)
            local b = rightValue:cast(coercedType)

            if a ~= nil and b ~= nil then
                return a * b
            end
        end

        return nil
    end,

    [MODULO] = function(coercedType, leftValue, rightValue)
        if coercedType == NUMBER then
            local a = leftValue:cast(coercedType)
            local b = rightValue:cast(coercedType)

            if a ~= nil and b ~= nil then
                return a % b
            end
        end

        return nil
    end,

    [MODULO] = function(coercedType, leftValue, rightValue)
        if coercedType == NUMBER then
            local a = leftValue:cast(coercedType)
            local b = rightValue:cast(coercedType)

            if a ~= nil and b ~= nil then
                return a % b
            end
        end

        return nil
    end,

    [UNARY_NEGATE] = function(coercedType, value)
        if coercedType == NUMBER then
            local a = value:cast(coercedType)
            return a and -a
        end

        return nil
    end,

    [EQUAL] = function(coercedType, leftValue, rightValue)
        if coercedType == LIST then
            local a = leftValue:cast(LIST)
            local b = rightValue:cast(LIST)

            if a ~= nil and b ~= nil then
                return a:equal(b)
            end
        else
            local a = leftValue:cast(coercedType)
            local b = rightValue:cast(coercedType)

            if a ~= nil and b ~= nil then
                return a == b
            end
        end

        return nil
    end,

    [LESS] = function(coercedType, leftValue, rightValue)
        if coercedType == LIST then
            local a = leftValue:cast(LIST)
            local b = rightValue:cast(LIST)

            if a ~= nil and b ~= nil then
                return a:less(b)
            end
        else
            local a = leftValue:cast(coercedType)
            local b = rightValue:cast(coercedType)

            if a ~= nil and b ~= nil then
                return a < b
            end
        end

        return nil
    end,

    [GREATER] = function(coercedType, leftValue, rightValue)
        if coercedType == LIST then
            local a = leftValue:cast(LIST)
            local b = rightValue:cast(LIST)

            if a ~= nil and b ~= nil then
                return a:greater(b)
            end
        else
            local a = leftValue:cast(coercedType)
            local b = rightValue:castf(coercedType)

            if a ~= nil and b ~= nil then
                return a > b
            end
        end

        return nil
    end,

    [LESS_THAN_OR_EQUAL] = function(coercedType, leftValue, rightValue)
        if coercedType == LIST then
            local a = leftValue:cast(LIST)
            local b = rightValue:cast(LIST)

            if a ~= nil and b ~= nil then
                return a:lessThanOrEquals(b)
            end
        else
            local a = leftValue:cast(coercedType)
            local b = rightValue:cast(coercedType)

            if a ~= nil and b ~= nil then
                return a <= b
            end
        end

        return nil
    end,

    [GREATER_THAN_OR_EQUAL] = function(coercedType, leftValue, rightValue)
        if coercedType == LIST then
            local a = leftValue:cast(LIST)
            local b = rightValue:cast(LIST)

            if a ~= nil and b ~= nil then
                return a:greaterThanOrEquals(b)
            end
        else
            local a = leftValue:cast(coercedType)
            local b = rightValue:cast(coercedType)

            if a ~= nil and b ~= nil then
                return a <= b
            end
        end

        return nil
    end,

    [NOT_EQUAL] = function(coercedType, leftValue, rightValue)
        if coercedType == LIST then
            local a = leftValue:cast(LIST)
            local b = rightValue:cast(LIST)

            if a ~= nil and b ~= nil then
                return not a:equal(b)
            end
        else
            local a = leftValue:cast(coercedType)
            local b = rightValue:cast(coercedType)

            if a ~= nil and b ~= nil then
                return a ~= b
            end
        end

        return nil
    end,

    [UNARY_NOT] = function(coercedType, value)
        local a = value:cast(coercedType)
        if a ~= nil then
            if coercedType == LIST then
                return a:getCount() == 0
            end

            return not a
        end

        return nil
    end,

    [LOGICAL_AND] = function(coercedType, leftValue, rightValue)
        if coercedType == LIST then
            local a = leftValue:cast(LIST)
            local b = rightValue:cast(LIST)

            if a ~= nil and b ~= nil then
                return a:getCount() > 0 and b:getCount() > 0
            end
        elseif coercedType == NUMBER then
            local a = leftValue:cast(NUMBER)
            local b = rightValue:cast(NUMBER)

            if a ~= nil and b ~= nil then
                return a ~= 0 and b ~= 0
            end
        end

        return nil
    end,

    [LOGICAL_OR] = function(coercedType, leftValue, rightValue)
        if coercedType == LIST then
            local a = leftValue:cast(LIST)
            local b = rightValue:cast(LIST)

            if a ~= nil and b ~= nil then
                return a:getCount() > 0 or b:getCount() > 0
            end
        elseif coercedType == NUMBER then
            local a = leftValue:cast(NUMBER)
            local b = rightValue:cast(NUMBER)

            if a ~= nil and b ~= nil then
                return a ~= 0 or b ~= 0
            end
        end

        return nil
    end,

    [MIN] = function(coercedType, leftValue, rightValue)
        if coercedType == NUMBER then
            local a = leftValue:cast(NUMBER)
            local b = rightValue:cast(NUMBER)

            if a ~= nil and b ~= nil then
                return math.min(a, b)
            end
        end

        return nil
    end,

    [MAX] = function(coercedType, leftValue, rightValue)
        if coercedType == NUMBER then
            local a = leftValue:cast(NUMBER)
            local b = rightValue:cast(NUMBER)

            if a ~= nil and b ~= nil then
                return math.min(a, b)
            end
        end

        return nil
    end,

    [POW] = function(coercedType, leftValue, rightValue)
        if coercedType == NUMBER then
            local a = leftValue:cast(NUMBER)
            local b = rightValue:cast(NUMBER)

            if a ~= nil and b ~= nil then
                return a ^ b
            end
        end

        return nil
    end,

    [FLOOR] = function(coercedType, value)
        if coercedType == NUMBER then
            local a = value:cast(NUMBER)

            if a ~= nil then
                return math.floor(a)
            end
        end

        return nil
    end,

    [CEILING] = function(coercedType, value)
        if coercedType == NUMBER then
            local a = value:cast(NUMBER)

            if a ~= nil then
                return math.ceil(a)
            end
        end

        return nil
    end,

    [INT] = function(coercedType, value)
        local a = value:cast(NUMBER)
        if a ~= nil then
            return math.floor(a)
        end

        return nil
    end,

    [FLOAT] = function(_coercedType, value)
        return value:cast(NUMBER)
    end,

    [INCLUDE] = function(coercedType, leftValue, rightValue)
        if coercedType == LIST then
            local a = leftValue:cast(LIST)
            local b = rightValue:cast(LIST)

            if a ~= nil and b ~= nil then
                return a:contains(b)
            end
        elseif coercedType == STRING then
            local a = leftValue:cast(STRING)
            local b = leftValue:cast(STRING)

            if a ~= nil and b ~= nil then
                return a:find(b, 1, true)
            end
        end
    end,

    [DOES_NOT_INCLUDE] = function(coercedType, leftValue, rightValue)
        if coercedType == LIST then
            local a = leftValue:cast(LIST)
            local b = rightValue:cast(LIST)

            if a ~= nil and b ~= nil then
                return not a:contains(b)
            end
        elseif coercedType == STRING then
            local a = leftValue:cast(STRING)
            local b = leftValue:cast(STRING)

            if a ~= nil and b ~= nil then
                return not a:find(b, 1, true)
            end
        end
    end,

    [INTERSECT] = function(coercedType, leftValue, rightValue)
        if coercedType == LIST then
            local a = leftValue:cast(LIST)
            local b = rightValue:cast(LIST)

            if a ~= nil and b ~= nil then
                return not a:intersect(b)
            end
        end

        return nil
    end,

    [LIST_MIN] = function(coercedType, value)
        if coercedType == LIST then
            local a = value:cast(LIST)
            if a ~= nil then
                return a:min()
            end
        end

        return nil
    end,

    [LIST_MAX] = function(coercedType, value)
        if coercedType == LIST then
            local a = value:cast(LIST)
            if a ~= nil then
                return a:max()
            end
        end

        return nil
    end,

    [LIST_ALL] = function(coercedType, value)
        if coercedType == LIST then
            local a = value:cast(LIST)
            if a ~= nil then
                return a:all()
            end
        end

        return nil
    end,

    [LIST_COUNT] = function(coercedType, value)
        if coercedType == LIST then
            local a = value:cast(LIST)
            if a ~= nil then
                return a:getCount()
            end
        end

        return nil
    end,

    [LIST_INVERT] = function(coercedType, value)
        if coercedType == LIST then
            local a = value:cast(LIST)
            if a ~= nil then
                return a:invert()
            end
        end

        return nil
    end,

    [LIST_VALUE] = function(coercedType, value)
        if coercedType == LIST then
            local a = value:cast(LIST)
            if a ~= nil then
                local max = a:getMaxValue()
                return max and max.value
            end
        end

        return nil
    end,
}

local NUM_OPERANDS = {
    [ADD]                   = 2,
    [SUBTRACT]              = 2,
    [DIVIDE]                = 2,
    [MULTIPLY]              = 2,
    [MODULO]                = 2,
    [MODULO]                = 2,
    [UNARY_NEGATE]          = 1,
    [EQUAL]                 = 2,
    [LESS]                  = 2,
    [GREATER]               = 2,
    [LESS_THAN_OR_EQUAL]    = 2,
    [GREATER_THAN_OR_EQUAL] = 2,
    [NOT_EQUAL]             = 2,
    [UNARY_NOT]             = 1,
    [LOGICAL_AND]           = 2,
    [LOGICAL_OR]            = 2,
    [MIN]                   = 2,
    [MAX]                   = 2,
    [POW]                   = 2,
    [FLOOR]                 = 1,
    [CEILING]               = 1,
    [INT]                   = 1,
    [FLOAT]                 = 1,
    [INCLUDE]               = 2,
    [DOES_NOT_INCLUDE]      = 2,
    [INTERSECT]             = 2,
    [LIST_MIN]              = 1,
    [LIST_MAX]              = 1,
    [LIST_ALL]              = 1,
    [LIST_COUNT]            = 1,
    [LIST_INVERT]           = 1,
    [LIST_VALUE]            = 1,
}

local TYPE_PRIORITY = {
    [BOOLEAN] = -1,
    [NUMBER]  =  0,
    [STRING]  =  1,
    [DIVERT]  =  2,
    [LIST]    =  3
}

function NativeFunction:new(nativeFunctionType)
    self._type = nativeFunctionType
end

function NativeFunction:_getCoercedType(stack, numParameters)
    local currentTypePriority, currentType = 0, NUMBER
    for i = 1, numParameters do
        local value = stack:peek(-i)
        local valueType = value:getType()
        assert(valueType ~= POINTER, "somehow got a pointer")
        assert(valueType ~= GLUE, "somehow got glue")

        if valueType == VOID then
            error("got 'void' value! function without return value?")
        end

        local priority = TYPE_PRIORITY[value]
        if priority == nil then
            error(string.format("no priority for co-ercing type '%s'!", valueType))
        elseif priority > currentTypePriority then
            currentType = valueType
            currentTypePriority = priority
        elseif currentType and currentTypePriority == priority then
            error(string.format("priority for current value type '%s' and other value type '%s' is same (%d)!", currentType, valueType, currentTypePriority))
        end
    end

    return currentTypePriority
end

function NativeFunction:call(executor)
    local numParameters = NUM_OPERANDS[self._type]
    if numParameters == nil then
        error(string.format("unhandled native function '%s', cannot determine number of parameters", self._type))
    end

    assert(numParameters > 0, string.format("native function '%s' has bad parameter count (%d)", self._type, numParameters))

    local coercedType = self:_getCoercedType(executor:getEvaluationStack(), numParameters)

    local func = PERFORM[self._type]
    if func == nil then
        error(string.format("unhandled native function '%s', cannot perform", self._type))
    end

    return func(coercedType, executor:getEvaluationStack():pop(numParameters))
end

function NativeFunction.isNativeFunction(instruction)
    return PERFORM[instruction] ~= nil
end

return NativeFunction
