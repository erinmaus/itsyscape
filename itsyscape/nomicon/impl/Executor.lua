local PATH = (...):gsub("%.[^%.]+$", "")
local Choice = require(PATH .. "Choice")
local Constants = require(PATH .. "Constants")
local Class = require(PATH .. "Class")
local Flow = require(PATH .. "Flow")
local GlobalVariables = require(PATH .. "GlobalVariables")
local Value = require(PATH .. "Value")

local Executor = Class()

function Executor:new(root, listDefinitions, globalVariables)
    self._root = root
    self._listDefinitions = listDefinitions

    self._visitCounts = {}
    self._turnCounts = {}

    self._currentTurnCount = 0

    self._choices = {}
    self._choiceCount = 0

    self._flows = {}
    self._defaultFlow = Flow(self, "default")
    self._currentFlow = self._defaultFlow

    self._externalFuncs = {}
    self._isCallingExternalFunction = false

    self._globalVariables = GlobalVariables(globalVariables)

    if love and love.math then
        local rng = love.math.newRandomGenerator()
        local seed = {}

        self._setSeedFunc = function(seed)
            if type(seed) == "table" and #seed == 2 then
                rng:setSeed((table.unpack or unpack)(seed))
            else
                rng:setSeed(seed)
            end
        end

        self._getSeedFunc = function()
            seed[1], seed[2] = rng:getSeed()
            return seed
        end

        self._random = function(min, max)
            return rng:random(min, max)
        end
    else
        -- No implementation for vanilla Lua/LuaJIT...
        self._setSeedFunc = function(_seed) end
        self._getSeedFunc = function() return 0 end
        self._randomFunc = function(min, _max) return min end
    end
end

function Executor:clean()
    self._defaultFlow:clean()

    for _, flow in pairs(self._flows) do
        flow:clean()
    end

    while #self._choices > self._choiceCount do
        table.remove(self._choices, #self._choices)
    end
end

function Executor:setRandom(setSeedFunc, getSeedFunc, randomFunc)
    self._setSeedFunc = setSeedFunc
    self._getSeedFunc = getSeedFunc
    self._randomFunc = randomFunc
end

function Executor:random(min, max)
    return self._randomFunc(min, max)
end

function Executor:setRandomSeed(seed)
    self._setSeedFunc(seed)
end

function Executor:getRandomSeed()
    return self._getSeedFunc()
end

function Executor:getRootContainer()
    return self._root
end

function Executor:getListDefinitions()
    return self._listDefinitions
end

function Executor:getContainer(path)
    return self._currentFlow:getCurrentThread():getContainer(path)
end

function Executor:getPointer(path)
    return self._currentFlow:getCurrentThread():getPointer(path)
end

function Executor:getCurrentFlow()
    return self._currentFlow
end

function Executor:getCurrentPointer()
    return self._currentFlow:getCurrentThread():getCurrentPointer()
end

function Executor:getPreviousPointer()
    return self._currentFlow:getCurrentThread():getPreviousPointer()
end

function Executor:getGlobalVariable(key)
    return self._globalVariables:get(key)
end

function Executor:setGlobalVariable(key, value)
    if self._isCallingExternalFunction then
        self._globalVariables:set(key, value, false)
        return
    end

    self._isCallingExternalFunction = true
    local success, result = pcall(self._globalVariables.set, self._globalVariables, key, value, true)
    self._isCallingExternalFunction = false

    if not success then
        error(string.format("error setting global variable '%s': %s", key, result))
    end
end

function Executor:_getTemporaryVariables(contextIndex)
    local callStack = self._currentFlow:getCurrentThread():getCallStack()

    if contextIndex then
        if contextIndex < 0 then
            error("context index not yet determined")
        elseif contextIndex == 0 then
            error("context index is global")
        elseif contextIndex > callStack:getFrameCount() then
            error("context index it out of bounds")
        end
    end

    local callStackFrame = callStack:getFrame(contextIndex or -1)
    return callStackFrame:getTemporaryVariables()
end

function Executor:getTemporaryVariable(key, contextIndex)
    self:_getTemporaryVariables(contextIndex):get(key)
end

function Executor:setTemporaryVariable(key, value, contextIndex)
    self:_getTemporaryVariables(contextIndex):set(key, value)
end

function Executor:visit(container, isStart)
    if container:getShouldOnlyCountAtStart() and not isStart then
        return
    end

    local pathName = container:getPath():toString()
    if container:getShouldCountTurns() then
        self._turnCounts[pathName] = self:getTurnCount()
    end

    if container:getShouldCountVisits() then
        self._visitCounts[pathName] = (self._visitCounts[pathName] or 0) + 1
    end
end

function Executor:getTurnCountForContainer(container)
    if not container:getShouldCountTurns() then
        return -1
    end

    local pathName = container:getPath():toString()
    local turnCount = self._turnCounts[pathName]
    return turnCount and turnCount - self._currentTurnCount or -1
end

function Executor:getVisitCountForContainer(container)
    if not container:getShouldCountVisits() then
        return -1
    end

    local pathName = container:getPath():toString()
    return self._visitCounts[pathName] or 0
end

function Executor:getEvaluationStack()
    return self._currentFlow:getEvaluationStack()
end

function Executor:getCallStack()
    return self._currentFlow:getCurrentThread():getCallStack()
end

function Executor:enterLogicalEvaluation()
    return self._currentFlow:getCurrentThread():enterLogicalEvaluation()
end

function Executor:leaveLogicalEvaluation()
    return self._currentFlow:getCurrentThread():leaveLogicalEvaluation()
end

function Executor:startStringEvaluation()
    return self._currentFlow:getCurrentThread():startStringEvaluation()
end

function Executor:stopStringEvaluation()
    return self._currentFlow:getCurrentThread():stopStringEvaluation()
end

function Executor:enterTag()
    return self._currentFlow:getCurrentThread():enterTag()
end

function Executor:leaveTag()
    self._currentFlow:getCurrentThread():leaveTag()
end

function Executor:getTurnCount()
    return self._currentTurnCount
end

function Executor:incrementTurnCount()
    self._currentTurnCount = self._currentTurnCount + 1
end

function Executor:startThread()
    self._currentFlow:push()
end

function Executor:done()
    self._currentFlow:done()
end

function Executor:stop()
    self._currentFlow:stop()
end

function Executor:getIsStopped()
    return not self._currentFlow:canPop() and self._currentFlow:getCurrentThread():getCallStack():getFrameCount() == 0
end

function Executor:addChoice(choicePoint)
    return self._currentFlow:addChoice(choicePoint)
end

function Executor:getNumChoices()
    return self._currentFlow:getNumChoices()
end

function Executor:getChoice(index)
    return self._currentFlow:getChoice(index)
end

function Executor:clearChoices()
    self._choiceCount = 0
end

function Executor:_choosePath(path)
    local container, index = self:getPointer(path)
    if not container or not index then
        error(string.format("could not change path to '%s'", path))
    end

    local callStack = self._currentFlow:getCurrentThread():getCallStack()
    if callStack:getFrameCount() == 0 then
        self:divertToPointer(Constants.DIVERT_START, container, index)
    else
        self:divertToPointer(Constants.DIVERT_TO_PATH, container, index)
    end
end

function Executor:_chooseChoice(choice)
    if not choice:getIsSelectable() then
        return false
    end
end

function Executor:divertToPointer(divertType, container, index)
    self._currentFlow:divertToPointer(divertType, container, index)
end

function Executor:divertToExternal(name, numArgs)
    local externalFunction = self._externalFuncs[name]
    if not externalFunction then
        local container = self:getContainer(name)

        if container then
            self:divertToPointer(Constants.DIVERT_TO_FUNCTION, container, 1)
        else
            error(string.format("could not find external function or knot with name '%s' when trying to call an external function", name))
        end

        return
    end

    -- Since it's a stack, the last value popped will be the first argument.
    -- We need to flip the offset, so offset goes from numArgs .. 1.
    --
    -- However, if we naively flip the offset, we might add to the hash part of the table
    -- instead of the array when #externalFunctions.args < externalFunction.n + numArgs.
    -- So reserve that space ahead of time.
    for _ = #externalFunction.args, externalFunction.n + numArgs do
        table.insert(externalFunction.args, Value.VOID)
    end

    for i = 1, numArgs do
        local value = self:getEvaluationStack():pop()

        if externalFunction.marshal then
            value = value:getValue()
        end

        local offset = (numArgs - i + 1)
        externalFunction.args[externalFunction.n + offset] = value
    end

    self._isCallingExternalFunction = true
    local success, result = pcall(externalFunction.func, (table.unpack or unpack)(externalFunction.args, 1, externalFunction.n + numArgs))
    self._isCallingExternalFunction = false

    if not success then
        error(string.format("error running external function '%s': %s", name, result))
    end

    result = result == nil and Value.VOID or Value(nil, result)
    self:getEvaluationStack():push(result)
end

function Executor:start(path)
    self:stop()

    local container = self:getContainer(path)
    self._currentFlow:getCurrentThread():getCallStack():enter(Constants.DIVERT_START, container, 1)
end

function Executor:call(path, ...)
    if self._isCallingExternalFunction then
        error("cannot call function while in external function")
    end
    
    local container, index = self:getPointer(path)
    self:divertToPointer(Constants.DIVERT_TO_FUNCTION, container, index)

    local beforeEvaluationStackCount = self:getEvaluationStack():getCount()
    self:continue()
    local afterEvaluationStackCount = self:getEvaluationStack():getCount()

    local numReturnValues = afterEvaluationStackCount - beforeEvaluationStackCount
    return self:getEvaluationStack():pop(numReturnValues)
end

function Executor:choose(value)
    if Class.isDerived(Class.getType(value), Choice) then
        return self:_chooseChoice(value)
    else
        return self:_choosePath(value) 
    end
end

function Executor:_divert()
    local thread = self._currentFlow:getCurrentThread()
    local divertType = thread:getDivertedPointerType()
    local container, index = thread:getDivertedPointer()

    if divertType == Constants.DIVERT_TO_FUNCTION or divertType == Constants.DIVERT_TO_TUNNEL then
        thread:getCallStack():enter(divertType, container, index)
    else
        thread:getCallStack():jump(container, index)
    end

    thread:clearDivertedPointer()

    local previousContainer = thread:getPreviousPointer()
    local currentContainer = thread:getCurrentPointer()

    local index
    if not previousContainer then
        index = 2
    elseif currentContainer then
        local parent = currentContainer:getPath():getCommonParent(previousContainer:getPath())
        local _, parentIndex = currentContainer:getPath():contains(parent)

        index = parentIndex
    else
        return
    end

    local path = currentContainer:getPath()
    local isStart = true
    for i = index, path:getNumComponents() do
        local child = path:getComponent(i)
        local name = child:getName()
        isStart = isStart and name == 1 and child:getShouldOnlyCountAtStart()

        self:visit(child, isStart)
    end
end

function Executor:_advancePointer()
    local thread = self._currentFlow:getCurrentThread()

    thread:updatePreviousPointer()
    
    if thread:hasDivertedPointer() then
        self:_divert()
    end
end

function Executor:_execute()
    local container, index = self._currentFlow:getCurrentThread():getCurrentPointer()
    if not (container and index) then
        return
    end
    
    local instruction = container:getContent(index)
    if instruction then
        instruction:call(self)
    end
end

function Executor:step()
    self:_advancePointer()
    self:_execute()
    self:_
end

function Executor:canContinue()
    return self._currentFlow:getCurrentThread():getCurrentPointer() ~= nil
end

function Executor:continue()
    while self:canContinue() and self:getNumChoices() == 0 do
        self:step()

        if self:getNumChoices() == 1 then
            local choice = self:getChoice(1)
            if choice:getChoicePoint():getIsInvisibleDefault() then
                self:choose(choice)
            end
        end
    end
end

return Executor
