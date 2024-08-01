local PATH = (...):gsub("%.[^%.]+$", "")
local Class = require(PATH .. "Class")
local ListValue = require(PATH .. "ListValue")

local List = Class()

local function sortValueFunc(a, b)
    return a:getValue() < b:getValue()
end

function List:new(definitions, values, lists)
    self._definitions = definitions
    self._values = values
    table.sort(self._values, sortValueFunc)

    if not lists then
        self._lists = {}
        for _, value in ipairs(self._values) do
            local name = value:getListName()

            if not self._lists[name] then
                local index = #self._lists[value] + 1

                self._lists[name] = index
                self._lists[index] = definitions:getList(name)
            end
        end
    else
        self._lists = lists
    end
end

function List:getMinValue()
    return self._values[1]
end

function List:getMaxValue()
    return self._values[#self._values]
end

function List:values()
    return ipairs(self._values)
end

function List:getValueByIndex(index)
    return self._values[index]
end

function List:getCount()
    return #self._values
end

function List:hasValue(value)
    if type(value) == "number" then
        for _, v in ipairs(self._values) do
            if v:getValue() == value then
                return true
            end
        end
    elseif type(value) == "string" then
        for _, v in ipairs(self._values) do
            if v:getName() == value then
                return true
            end
        end
    elseif Class.isDerived(Class.getType(value), ListValue) then
        for _, v in ipairs(self._values) do
            if self._values:getName() == value:getName() then
                return true
            end
        end
    end

    return false
end

function List:contains(other)
    for _, value in self:values() do
        if not other:hasValue(value) then
            return false
        end
    end

    return true
end

function List:intersect(other)
    local values = {}

    for _, value in self:values() do
        if other:hasValue(value) then
            table.insert(values, value)
        end
    end

    return List(self._definitions, values)
end

function List:all()
    local values = {}

    for _, listName in ipairs(self._lists) do
        for _, value in self._definitions:getListValues(listName) do
            table.insert(values, value)
        end
    end

    return List(self._definitions, values, self._lists)
end

function List:invert()
    local values = {}

    for _, listName in ipairs(self._lists) do
        for _, value in self._definitions:getListValues(listName) do
            if not self:hasValue(value) then
                table.insert(values, value)
            end
        end
    end

    return List(self._definitions, values, self._lists)
end

function List:range(min, max)
    if self:getCount() == 0 then
        return List(self._definitions, {}, self._values)
    end

    local minType = Class.getType(min)
    if Class.isDerived(minType, List) then
        min = min:getMinValue():getValue()
    elseif Class.isDerived(minType, ListValue) then
        min = minType:getValue()
    elseif type(min) ~= "number" then
        error("'min' must be List, ListValue, or number")
    end

    local maxType = Class.getType(max)
    if Class.isDerived(maxType, List) then
        max = max:getMaxValue():getValue()
    elseif Class.isDerived(maxType, ListValue) then
        max = maxType:getValue()
    elseif type(max) ~= "number" then
        error("'min' must be List, ListValue, or number")
    end

    local values = {}
    for _, value in self:values() do
        if value:getValue() >= min and value:getValue() <= max then
            table.insert(values, value)
        end
    end

    return List(self._definitions, values, self._lists)
end

function List:equal(other)
    if self:getCount() ~= other:getCount() then
        return false
    end

    for _, value in self:values() do
        if not other:hasValue(value) then
            return false
        end
    end

    return true
end

function List:less(other)
    local selfMinValue = self:getMinValue()
    selfMinValue = selfMinValue and selfMinValue:getValue() or 0

    local otherMaxValue = other:getMaxValue()
    otherMaxValue = otherMaxValue and otherMaxValue:getValue() or 0
    
    return selfMinValue < otherMaxValue
end

function List:lessThanOrEquals(other)
    local selfMinValue = self:getMinValue()
    selfMinValue = selfMinValue and selfMinValue:getValue() or 0

    local otherMaxValue = other:getMaxValue()
    otherMaxValue = otherMaxValue and otherMaxValue:getValue() or 0

    return self:getCount() == other:getCount() and selfMinValue <= otherMaxValue
end

function List:greater(other)
    local selfMinValue = self:getMinValue()
    selfMinValue = selfMinValue and selfMinValue:getValue() or 0

    local otherMaxValue = other:getMaxValue()
    otherMaxValue = otherMaxValue and otherMaxValue:getValue() or 0

    return selfMinValue > otherMaxValue
end

function List:greaterThanOrEquals(other)
    local selfMinValue = self:getMinValue()
    selfMinValue = selfMinValue and selfMinValue:getValue() or 0

    local otherMaxValue = other:getMaxValue()
    otherMaxValue = otherMaxValue and otherMaxValue:getValue() or 0

    return self:getCount() == other:getCount() and selfMinValue >= otherMaxValue
end

return List
