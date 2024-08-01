local PATH = (...):gsub("%.[^%.]+$", "")
local Class = require(PATH .. "Class")

local ListValue = Class()

function ListValue:new(listName, valueName, value)
    self._name = string.format("%s.%s", listName, valueName)
    self._listName = listName
    self._valueName = valueName
    self._value = value
end

function ListValue:getName()
    return self._name
end

function ListValue:getValueName()
    return self._valueName
end

function ListValue:getListName()
    return self._listName
end

function ListValue:getValue()
    return self._value
end

return ListValue
