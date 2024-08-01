local PATH = (...):gsub("%.[^%.]+$", "")
local Class = require(PATH .. "Class")
local CallStack = require(PATH .. "CallStack")
local Constant = require(PATH .. "Constant")

local Thread = Class()

function Thread:new(executor)
    self._executor = executor
    self._callStack = CallStack(executor)
end

function Thread:getPreviousPointer()
    return self._previousContainer, self._previousContainerIndex
end

function Thread:getCurrentPointer()
    if self._callStack:hasFrames() then
        return self._callStack:getFrame():getPointer()
    end

    return nil, nil
end

function Thread:updatePreviousPointer()
    if self._callStack:hasFrames() then
        local frame = self._callStack:getFrame()
        self._previousContainer, self._previousContainerIndex = frame:getPointer()
    end
end

function Thread:getContainer(path)
    local parentContainer
    if path:sub(1, 1) == Constant.PATH_RELATIVE then
        parentContainer = self:getCurrentPointer()
    else
        parentContainer = self._executor:getRootContainer()
    end

    if not parentContainer then
        return nil
    end

    return parentContainer:search(path)
end

function Thread:getCallStack()
    return self._callStack
end

function Thread:copy(other)
    other = other or Thread(self._executor, self._id)

    self._callStack:copy(other._callStack)

    other._previousContainer = self._previousContainer
    other._previousContainerIndex = self._previousContainerIndex

    return other
end

return Thread
