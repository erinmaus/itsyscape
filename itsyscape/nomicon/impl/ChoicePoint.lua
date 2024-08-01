local bit = require("bit")
local PATH = (...):gsub("%.[^%.]+$", "")
local Class = require(PATH .. "Class")
local Constants = require(PATH .. "Constants")

local ChoicePoint = Class()

function ChoicePoint:new(container, object)
    self._container = container
    self._object = object
    self._targetContainer = container:search(object[Constants.FIELD_CHOICE_POINT_PATH])
    self._flags = object[Constants.FIELD_FLAGS] or Constants.FLAG_CHOICE_POINT_ONLY_ONCE
end

function ChoicePoint:getContainer()
    return self._container
end

function ChoicePoint:getObject()
    return self._object
end

function ChoicePoint:getHasCondition()
    return bit.band(self._flags, Constants.FLAG_CHOICE_POINT_HAS_CONDITION) ~= 0
end

function ChoicePoint:getHasStartContent()
    return bit.band(self._flags, Constants.FLAG_CHOICE_POINT_HAS_START_CONTENT) ~= 0
end

function ChoicePoint:getHasEndContent()
    return bit.band(self._flags, Constants.FLAG_CHOICE_POINT_HAS_END_CONTENT) ~= 0
end

function ChoicePoint:getIsInvisibleDefault()
    return bit.band(self._flags, Constants.FLAG_CHOICE_POINT_IS_INVISIBLE_DEFAULT) ~= 0
end

function ChoicePoint:getShowOnlyOnce()
    return bit.band(self._flags, Constants.FLAG_CHOICE_POINT_ONLY_ONCE) ~= 0
end

function ChoicePoint.isChoicePoint(instruction)
    return type(instruction) == "table" and instruction[Constants.FIELD_CHOICE_POINT_PATH] ~= nil
end

function ChoicePoint:call(executor)
    local isSelectable
    if self:getHasCondition() then
        local value = executor:getEvaluationStack():pop()
        isSelectable = not not value:cast(Constants.TYPE_BOOLEAN)
    else
        isSelectable = true
    end

    local startChoiceText, endChoiceText
    local tags = {}
    if self:getHasStartContent() then
        startChoiceText = executor:getOutputStack():pop():cast(Constants.TYPE_STRING) or ""

        while executor:getOutputStack():peek():is(Constants.TYPE_TAG) do
            local tag = executor:getOutputStack():pop():cast(Constants.TYPE_STRING)
            if tag then
                table.insert(tags, tag)
            end
        end
    end

    if self:getHasEndContent() then
        endChoiceText = executor:getOutputStack():pop():cast(Constants.TYPE_STRING) or ""

        while executor:getOutputStack():peek():is(Constants.TYPE_TAG) do
            local tag = executor:getOutputStack():pop():cast(Constants.TYPE_STRING)
            if tag then
                table.insert(tags, tag)
            end
        end
    end

    if self:getShowOnlyOnce() then
        isSelectable = isSelectable and (executor:getVisitCountForContainer(self._targetContainer) == 0)
    end

    local choice = executor:addChoice(self)
    choice:setStartText(startChoiceText)
    choice:setEndText(endChoiceText)
    choice:addTags(tags)
    choice:setIsSelectable(isSelectable)
end

return ChoicePoint
