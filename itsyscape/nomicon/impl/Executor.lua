local PATH = (...):gsub("%.[^%.]+$", "")
local Choice = require(PATH .. "Choice")
local Class = require(PATH .. "Class")
local Flow = require(PATH .. "Flow")

local Executor = Class()

function Executor:new(root)
    self._root = root

    self._visitCounts = {}
    self._turnCounts = {}

    self._currentTurnCount = 0

    self._choices = {}
    self._choiceCount = 0

    self._flows = {}
    self._defaultFlow = Flow(self, "default")
    self._currentFlow = self._defaultFlow

    if love and love.math then
        local rng = love.math.newRandomGenerator()
        local seed = {}

        self._setSeedFunc = function(seed)
            if type(seed) == "table" and #seed == 2 then
                rng:setSeed(unpack(seed))
            else
                rng:setSeed(seed)
            end
        end

        self._getSeedFunc = function(seed)
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

function Executor:getContainer(path)
    return self._currentFlow:getCurrentThread():getContainer(path)
end

function Executor:getCurrentPointer()
    return self._currentFlow:getCurrentThread():getCurrentPointer()
end

function Executor:getPreviousPointer()
    return self._currentFlow:getCurrentThread():getPreviousPointer()
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
    self._currentFlow:getCallStack():clear()
end

function Executor:stop()
    self:done()
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

return Executor
