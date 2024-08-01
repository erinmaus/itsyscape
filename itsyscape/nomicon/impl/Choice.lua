local PATH = (...):gsub("%.[^%.]+$", "")
local Class = require(PATH .. "Class")
local Utility = require(PATH .. "Utility")

local Choice = Class()

function Choice:new(executor)
    self._executor = executor
    self:create(nil)
end

function Choice:create(choicePoint)
    self._choicePoint = choicePoint
    self._thread = self._executor:getCurrentFlow():fork()
    self._startText = ""
    self._endText = ""
    self._tags = Utility.clearTable(self._tags or {})
    self._isSelectable = true
end

function Choice:getChoicePoint()
    return self._choicePoint
end

function Choice:getExecutor()
    return self._executor
end

function Choice:getThread()
    return self._thread
end

function Choice:getStartText()
    return self._startText
end

function Choice:setStartText(value)
    self._startText = value
end

function Choice:getEndText()
    return self._endText
end

function Choice:setEndText(value)
    self._endText = value
end

function Choice:addTags(tags)
    for _, tag in ipairs(tags) do
        table.insert(self._tags, tag)
    end
end

function Choice:getNumTags()
    return #self._tags
end

function Choice:getTag(index)
    return self._tags[index]
end

function Choice:getIsSelectable()
    return self._isSelectable
end

return Choice
