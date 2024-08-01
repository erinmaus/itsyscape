local PATH = (...):gsub("%.[^%.]+$", "")
local Class = require(PATH .. "Class")
local Constants = require(PATH .. "Constants")

local Variable = Class()

local ASSIGN_GLOBAL_VARIABLE    = Constants.ASSIGN_GLOBAL_VARIABLE
local ASSIGN_TEMPORARY_VARIABLE = Constants.ASSIGN_TEMPORARY_VARIABLE

function Variable:new(object)
    self._object = object

    if object[ASSIGN_GLOBAL_VARIABLE] then
        self._type = ASSIGN_GLOBAL_VARIABLE
        self._name = object[ASSIGN_GLOBAL_VARIABLE]
    elseif object[ASSIGN_TEMPORARY_VARIABLE] then
        self._type = ASSIGN_TEMPORARY_VARIABLE
        self._name = object[ASSIGN_TEMPORARY_VARIABLE]
    end

    self._isCreate = not object[Constants.FIELD_VARIABLE_REASSIGNMENT]
end

function Variable:getType()
    return self._type
end

function Variable:getName()
    return self._name
end

function Variable:getIsGlobal()
    return self._type == ASSIGN_GLOBAL_VARIABLE
end

function Variable:getIsTemporary()
    return self._type == ASSIGN_TEMPORARY_VARIABLE
end

function Variable:getIsCreate()
    return self._isCreate
end

function Variable:assign(executor)
    local value = executor:getEvaluationStack():pop()
    
    if self:getIsGlobal() then
        executor:setGlobalVariable(self._name, value, self._isCreate)
    elseif self:getIsTemporary() then
        executor:setTemporaryVariable(self._name, value, self._isCreate)
    else
        error(string.format("unhandled variable assignment type '%s'", self._type))
    end
end

function Variable.isVariable(instruction)
    if type(instruction) ~= "table" then
        return false
    end

    local hasValue = instruction[ASSIGN_GLOBAL_VARIABLE] or instruction[ASSIGN_TEMPORARY_VARIABLE]
    return not not hasValue
end

return Variable
