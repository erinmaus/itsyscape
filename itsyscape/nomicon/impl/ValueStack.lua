local PATH = (...):gsub("%.[^%.]+$", "")
local Class = require(PATH .. "Class")
local Constants = require(PATH .. "Constants")
local Utility = require(PATH .. "Utility")

local ValueStack = Class()

function ValueStack:new()
    self._stack = {}
    self._top = 0
    self._string = {}
end

function ValueStack:copy(other)
    other = other or ValueStack()

    for i = 1, self._top do
        local selfValue = self._top[i]
        other._stack[i] = selfValue:copy(other._stack[i])
        other._string[i] = self._string[i]
    end
    other._top = self._top

    return other
end

function ValueStack:getCount()
    return self._top
end

function ValueStack:_toAbsoluteIndex(index)
    index = index or -1
    if index < 0 then
        index = self._top + index + 1
    end
    return index
end

function ValueStack:peek(index)
    index = self:_toAbsoluteIndex(index)
    if index >= 1 and index <= self._top then
        return self._stack[index]
    end

    return nil
end

function ValueStack:toString(startIndex, stopIndex)
    startIndex = self:_toAbsoluteIndex(startIndex)
    stopIndex = self:_toAbsoluteIndex(stopIndex)

    if stopIndex < startIndex then
        error("cannot convert to reversed string (stopIndex < startIndex)")
    end

    if not (startIndex >= 1 and startIndex <= self._top) then
        error(string.format("startIndex (%d) out of bounds", startIndex))
    end
    
    if not (stopIndex >= 1 and stopIndex <= self._top) then
        error(string.format("stopIndex (%d) out of bounds", stopIndex))
    end

    return table.concat(self._string, startIndex, stopIndex)
end

function ValueStack:unpack(startIndex, stopIndex)
    startIndex = self:_toAbsoluteIndex(startIndex)
    stopIndex = self:_toAbsoluteIndex(stopIndex)

    if stopIndex < startIndex then
        error("cannot convert to reversed string (stopIndex < startIndex)")
    end

    if not (startIndex >= 1 and startIndex <= self._top) then
        error(string.format("startIndex (%d) out of bounds", startIndex))
    end

    if not (stopIndex >= 1 and stopIndex <= self._top) then
        error(string.format("stopIndex (%d) out of bounds", stopIndex))
    end

    return (table.unpack or unpack)(startIndex, stopIndex)
end

function ValueStack:pop(count)
    count = count or 1

    if count <= 0 then
        error("cannot pop zero or less values")
    end

    if self._top <= 0 then
        assert(self._top == 0, "stack somehow became unbalance (less than 0 values)")
        error("cannot pop; no values in stack!")
    end

    if count > self._top then
        error("cannot pop more values than on stack")
    end

    local startIndex = self:_toAbsoluteIndex(-count)
    local stopIndex = self:_toAbsoluteIndex(-1)

    self._top = self._top - count

    return (table.unpack or unpack)(startIndex, stopIndex)
end

function ValueStack:push(value)
    self._top = self._top + 1

    local selfValue = self._stack[self._top]
    if not selfValue then
        selfValue = value:copy()
        self._stack[self._top] = selfValue
    end

    local success, value = selfValue:cast(Constants.TYPE_STRING)
    if success then
        assert(type(value) == "string", "cast to string but did not get string back")
        self._string[self._top] = value
    else
        self._string[self._top] = ""
    end

    return selfValue
end

return ValueStack
