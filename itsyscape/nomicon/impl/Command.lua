local PATH = (...):gsub("%.[^%.]+$", "")
local Class = require(PATH .. "Class")
local Constants = require(PATH .. "Constants")

local Command = Class()

local VOID    = Constants.TYPE_VOID
local STRING  = Constants.TYPE_STRING
local NUMBER  = Constants.TYPE_NUMBER
local BOOLEAN = Constants.TYPE_BOOLEAN
local DIVERT  = Constants.TYPE_DIVERT
local POINTER = Constants.TYPE_POINTER
local LIST    = Constants.TYPE_LIST

local BEGIN_LOGICAL_EVALUATION = Constants.COMMAND_BEGIN_LOGICAL_EVALUATION
local END_LOGICAL_EVALUATION   = Constants.COMMAND_END_LOGICAL_EVALUATION
local OUT                      = Constants.COMMAND_OUT
local POP                      = Constants.COMMAND_POP
local RETURN_TUNNEL            = Constants.COMMAND_RETURN_TUNNEL
local RETURN_FUNCTION          = Constants.COMMAND_RETURN_FUNCTION
local DUPLICATE                = Constants.COMMAND_DUPLICATE
local BEGIN_STRING_EVALUATION  = Constants.COMMAND_BEGIN_STRING_EVALUATION
local END_STRING_EVALUATION    = Constants.COMMAND_END_STRING_EVALUATION
local NO_OPERATION             = Constants.COMMAND_NO_OPERATION
local PUSH_CHOICE_COUNT        = Constants.COMMAND_PUSH_CHOICE_COUNT
local PUSH_TURN_COUNT          = Constants.COMMAND_PUSH_TURN_COUNT
local PUSH_COUNT_DIVERT_TURNS  = Constants.COMMAND_PUSH_COUNT_DIVERT_TURNS
local READ_COUNT               = Constants.COMMAND_READ_COUNT
local RANDOM                   = Constants.COMMAND_RANDOM
local SEED_RANDOM              = Constants.COMMAND_SEED_RANDOM
local PUSH_VISITS              = Constants.COMMAND_PUSH_VISITS
local PUSH_SHUFFLE_INDEX       = Constants.COMMAND_PUSH_SHUFFLE_INDEX
local START_THREAD             = Constants.COMMAND_START_THREAD
local DONE                     = Constants.COMMAND_DONE
local END                      = Constants.COMMAND_END
local PUSH_LIST_FROM_INT       = Constants.COMMAND_PUSH_LIST_FROM_INT
local PUSH_LIST_FROM_RANGE     = Constants.COMMAND_PUSH_LIST_FROM_RANGE
local PUSH_RANDOM_LIST         = Constants.COMMAND_PUSH_RANDOM_LIST
local BEGIN_TAG                = Constants.COMMAND_BEGIN_TAG
local END_TAG                  = Constants.COMMAND_END_TAG

local COMMANDS = {
    [BEGIN_LOGICAL_EVALUATION] = function(executor)
        executor:enterLogicalEvaluation()
    end,

    [END_LOGICAL_EVALUATION] = function(executor)
        executor:leaveLogicalEvaluation()
    end,

    [OUT] = function(executor)
        local value = executor:getEvaluationStack():pop()
        executor:getOutputStream():push(value)
    end,

    [POP] = function(executor)
        executor:getEvaluationStack():pop()
    end,

    [RETURN_TUNNEL] = function(executor)
        local value = executor:getEvaluationStack():pop()
        if value:is(DIVERT) or value:cast(DIVERT) then
            local divert = value:cast(DIVERT)
            executor:getCallStack():pop(divert)
        elseif value:is(VOID) then
            executor:getCallStack():pop()
        else
            error(string.format("expected DIVERT-compatible type or VOID, got '%s'", value:getType()))
        end
    end,

    [RETURN_FUNCTION] = function(executor)
        executor:getCallStack():pop()
    end,

    [DUPLICATE] = function(executor)
        local value = executor:getEvaluationStack():peek()
        executor:getEvaluationStack():push(value)
    end,

    [BEGIN_STRING_EVALUATION] = function(executor)
        executor:startStringEvaluation()
    end,

    [END_STRING_EVALUATION] = function(executor)
        executor:stopStringEvaluation()
    end,

    [NO_OPERATION] = function()
        -- Nothing.
    end,

    [PUSH_CHOICE_COUNT] = function(executor)
        executor:getEvaluationStack():push(executor:getChoices():getCount())
    end,

    [PUSH_TURN_COUNT] = function(executor)
        executor:getEvaluationStack():push(executor:getTurnCount())
    end,

    [PUSH_COUNT_DIVERT_TURNS] = function(executor)
        local value = executor:getEvaluationStack():pop()
        if not value:is(DIVERT) or not value:cast(DIVERT) then
            error(string.format("expected value of type DIVERT or co-ercable to DIVERT, got value of type '%s' instead", value:getType()))
        end

        local container = executor:getContainer(value:cast(DIVERT))
        if container then
            executor:getEvaluationStack():push(executor:getTurnCountForContainer(container))
        else
            executor:getEvaluationStack():push(-1)
        end
    end,

    [READ_COUNT] = function(executor)
        local value = executor:getEvaluationStack():pop()
        if not value:is(DIVERT) or not value:cast(DIVERT) then
            error(string.format("expected value of type DIVERT or co-ercable to DIVERT, got value of type '%s' instead", value:getType()))
        end

        local container = executor:getContainer(value:cast(DIVERT))
        if container then
            executor:getEvaluationStack():push(executor:getVisitCountForContainer(container))
        else
            executor:getEvaluationStack():push(-1)
        end
    end,

    [RANDOM] = function(executor)
        local minValue, maxValue = executor:getEvaluationStack():pop(2)

        local min = minValue:cast(NUMBER)
        local max = maxValue:cast(NUMBER)

        if min == nil then
            error(string.format("could not cast min value of type '%s' to 'NUMBER'", minValue:getType()))
        end

        if max == nil then
            error(string.format("could not cast min value of type '%s' to 'NUMBER'", maxValue:getType()))
        end

        min = math.floor(min)
        max = math.floor(max)

        local randomValue = executor:random(min, max)
        executor:getEvaluationStack():push(randomValue)
    end,

    [SEED_RANDOM] = function(executor)
        local value = executor:getEvaluationStack():pop(1)
        local seed = value:cast(NUMBER)
        if seed == nil then
            error(string.format("could not cast seed of type '%s' to 'NUMBER'", value:getType()))
        end

        executor:setRandomSeed(value)
    end,

    [PUSH_VISITS] = function(executor)
        local container = executor:getCurrentContainer()
        executor:getEvaluationStack():push(executor:getVisitCountForContainer(container) - 1)
    end,

    [PUSH_SHUFFLE_INDEX] = function(executor)
        local elementCountValue, sequenceCountValue = executor:getEvaluationStack():pop(2)

        local elementCount = elementCountValue:cast(NUMBER)
        if elementCount == nil then
            error(string.format("could not cast element count of type '%s' to 'NUMBER'", elementCountValue:getType()))
        elseif elementCount <= 1 then
            error("element count must be >= 1")
        end
        elementCount = math.floor(elementCount)

        local sequenceCount = sequenceCountValue:cast(NUMBER)
        if sequenceCount == nil then
            error(string.format("could not cast sequence count of type '%s' to 'NUMBER'", sequenceCountValue:getType()))
        end
        sequenceCount = math.floor(sequenceCount)

        local loopIndex = math.floor(sequenceCount / elementCount)
        local iterationIndex = sequenceCount % elementCount

        local currentRandomSeed = executor:getRandomSeed()
        do
            local container = executor:getCurrentContainer()
            local newRandomSeed = 0

            local path = container:getFullPath()
            for i = 1, #path do
                local newRandomSeed = newRandomSeed + path:byte(i, i)
            end

            executor:setRandomSeed(loopIndex + newRandomSeed)
        end

        local values = {}
        for i = 1, elementCount do
            table.insert(values, i)
        end

        local value
        for _ = 0, iterationIndex do
            local index = executor:random(1, #values)
            value = values[index]

            table.remove(values, index)
        end

        executor:getEvaluationStack():push(value)
        executor:setRandomSeed(currentRandomSeed)
    end,

    [START_THREAD] = function(executor)
        executor:startThread()
    end,

    [DONE] = function(executor)
        executor:done()
    end,

    [END] = function(executor)
        executor:stop()
    end,

    [PUSH_LIST_FROM_INT] = function(executor)
        local value, listNameValue = executor:getEvaluationStack():pop(2)

        local v = value:cast(NUMBER)
        if v == nil then
            error(string.format("could not cast list value of type '%s' to 'NUMBER'", value:getType()))
        end

        local listName = listNameValue:cast(STRING)
        if listName == nil then
            error(string.format("could not cast list name of type '%s' to 'STRING'", listNameValue:getType()))
        end

        local listDefinitions = executor:getListDefinitions()
        local newList = listDefinitions:newListFromValues(listName, v)

        executor:getEvaluationStack():push(newList)
    end,

    [PUSH_LIST_FROM_RANGE] = function(executor)
        local minValue, maxValue, listValue = executor:getEvaluationStack():pop(3)

        local min = minValue:cast(NUMBER)
        local max = maxValue:cast(NUMBER)
        local list = listValue:cast(LIST)

        if min == nil then
            error(string.format("could not cast min value of type '%s' to 'NUMBER'", minValue:getType()))
        end

        if max == nil then
            error(string.format("could not cast min value of type '%s' to 'NUMBER'", maxValue:getType()))
        end

        if list == nil then
            error(string.format("could not cast list value of type '%s' to 'LIST'", listValue:getType()))
        end

        min = math.floor(min)
        max = math.floor(max)

        local newList = list:range(min, max)
        executor:getEvaluationStack():push(newList)
    end,

    [PUSH_RANDOM_LIST] = function(executor)
        local listValue = executor:getEvaluationStack():pop(1)
        local list = listValue:cast(LIST)

        if list == nil then
            error(string.format("could not cast list value of type '%s' to 'LIST'", listValue:getType()))
        end

        local index = executor:random(1, list:getCount())
        local value = list:getValueByIndex(index)

        local newList = executor:getListDefinitions():newList(value)
        executor:getEvaluationStack():push(newList)
    end,

    [BEGIN_TAG] = function(executor)
        executor:enterTag()
    end,

    [END_TAG] = function(executor)
        executor:leaveTag()
    end
}

function Command:new(commandType, container, containerIndex)
    self._type = commandType
    self._container = container
    self._containerIndex = containerIndex
end

function Command:getType()
    return self._type
end

function Command:getPointer()
    return self._container, self._containerIndex
end

function Command:call(executor)
    local func = COMMANDS[self._type]
    if func then
        func(executor)
    end
end

function Command.isCommand(instruction)
    return COMMANDS[instruction] ~= nil
end

return Command
