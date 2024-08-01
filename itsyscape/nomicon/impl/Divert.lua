local PATH = (...):gsub("%.[^%.]+$", "")
local Class = require(PATH .. "Class")
local Constants = require(PATH .. "Constants")

local Divert = Class()

local PATH              = Constants.DIVERT_TO_PATH
local FUNCTION          = Constants.DIVERT_TO_FUNCTION
local TUNNEL            = Constants.DIVERT_TO_TUNNEL
local EXTERNAL_FUNCTION = Constants.DIVERT_TO_EXTERNAL_FUNCTION

function Divert:new(object)
    if object[PATH] then
        self._type = PATH
        self._path = object[PATH]
    elseif object[FUNCTION] then
        self._type = FUNCTION
        self._path = object[FUNCTION]
    elseif object[TUNNEL] then
        self._type = TUNNEL
        self._path = object[TUNNEL]
    elseif object[EXTERNAL_FUNCTION] then
        self._type = EXTERNAL_FUNCTION
        self._path = object[EXTERNAL_FUNCTION]
    else
        error("unsupported divert object")
    end

    self._isConditional = not not object[Constants.FIELD_DIVERT_IS_CONDITIONAL]
    self._isVariable = not not object[Constants.FIELD_DIVERT_IS_VARIABLE]

    self._object = object
end

function Divert:getType()
    return self._type
end

function Divert:getPath()
    if self._isVariable then
        return nil
    end

    return self._path
end

function Divert:getVariableIdentifier()
    if self._isVariable then
        return self._path
    end

    return nil
end

function Divert:getIsVariable()
    return self._isVariable
end

function Divert:getIsConditional()
    return self._isConditional
end

function Divert:getNumArgs()
    if self._type == EXTERNAL_FUNCTION and self._object then
        return self._object[Constants.FIELD_DIVERT_EXTERNAL_FUNCTION_ARGS] or 0
    end

    return nil
end

function Divert:call(executor)
    if self:getIsConditional() then
        local condition = executor:getEvaluationStack():pop()
        if condition:cast(Constants.TYPE_BOOLEAN) == false then
            return
        end
    end

    local path
    if self:getIsVariable() then
        local identifier = self:getVariableIdentifier()
        local value = executor:getTemporaryVariable(identifier) or executor:getGlobalVariable(identifier)
        if value == nil then
            error(string.format("could not divert using variable with name '%s' as target; variable not found", identifier))
        end

        path = value:cast(Constants.TYPE_DIVERT)
        if not path then
            error(string.format("could not divert using variable with name '%s' as target; variable has type '%s', expected 'DIVERT'", value:getType()))
        end
    end

    if self._type == EXTERNAL_FUNCTION then
        executor:divertToExternal(path, self:getNumArgs())
    else
        local container, index = executor:getPointer(path))
        executor:divertToPointer(self._type, container, index)
    end
end

function Divert.isDivert(instruction)
    if type(instruction) ~= "table" then
        return false
    end
    
    local hasValue = instruction[PATH] or instruction[FUNCTION] or instruction[TUNNEL] or instruction[EXTERNAL_FUNCTION]
    return not not hasValue
end

return Divert
