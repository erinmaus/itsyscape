local PATH = (...):gsub("%.[^%.]+$", "")
local Class = require(PATH .. "Class")
local CallStackFrame = require(PATH .. "CallStackFrame")

local CallStack = Class()

function CallStack:new(executor)
    self._executor = executor

    self._frames = {}
    self._top = 0
end

function CallStack:getExecutor()
    return self._executor
end

function CallStack:getEvaluationStack()
    return self._executor:getEvaluationStack()
end

function CallStack:getOutputStack()
    return self._executor:getOutputStack()
end

function CallStack:_toAbsoluteIndex(index)
    index = index or -1
    if index < 0 then
        index = self._top + index + 1
    end
    return index
end

function CallStack:getFrame(index)
    index = self:_toAbsoluteIndex(index)

    if index <= 0 or index > self._top then
        error(string.format("index %d is out of bounds for call stack", index))
    end

    return self._frames[index]
end

function CallStack:hasFrames()
    return self._top >= 1
end

function CallStack:clear()
    self._top = 0
end

function CallStack:enter(divertType, container)
    local frame

    local index = self._top + 1
    if index >= #self._frames then
        assert(index == #self._frames + 1, "call stack somehow got out of sync")

        frame = CallStackFrame(self)
        table.insert(self._frames, frame)
    else
        frame = self._frames[index]
    end

    frame:enter(divertType, container, index)
    self._top = index
end

function CallStack:leave(divertType)
    local frame = self:getFrame()
    frame:leave(divertType)

    self._top = self._top - 1
end

function CallStack:clean()
    while #self._frames > self._top do
        table.remove(self._frames, #self._top)
    end
end

function CallStack:copy(other)
    other = other or CallStack(self._executor)

    for i = 1, self._top do
        local selfFrame = self._frames[i]
        local otherFrame = selfFrame:copy(other._frames[i] or CallStackFrame(other))
        other._frames[i] = otherFrame
    end
    other._top = self._top

    return other
end

function CallStack:reset()
    self._top = 0
end

return CallStack
