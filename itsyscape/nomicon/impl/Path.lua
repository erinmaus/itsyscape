local PATH = (...):gsub("%.[^%.]+$", "")
local Class = require(PATH .. "Class")

local Path = Class()

function Path:new(container)
    self._container = container

    self._path = {}
    self._leaf = {}
    self:_buildAbsolutePath()
end

function Path:_buildAbsolutePath()
    local result = {}

    local current = self._container
    while current do
        table.insert(self._path, 1, current)

        local pathComponent = current:getName()
        if type(pathComponent) == "number" then
            pathComponent = tostring(pathComponent - 1)
        end

        table.insert(result, 1, pathComponent)
        current = self._container:getParent()
    end

    self._absolutePath = table.concat(result)
end

function Path:getNumComponents()
    return #self._path
end

function Path:_toAbsoluteIndex(index)
    index = index or -1
    if index < 0 then
        index = #self._path + index + 1
    end
    return index
end

function Path:getComponent(index)
    local container = self:getContainer(index)
    return container and container:getName()
end

function Path:getContainer(index)
    index = self:_toAbsoluteIndex(index)
    return self._path[index]
end

function Path:contains(otherContainer)
    for index, container in ipairs(self._path) do
        if container == otherContainer then
            return true, index
        end
    end

    return false
end

function Path:_getCommonParentIndex(otherPath)
    local currentIndex = 1
    local isSame, isOutOfBounds
    repeat
        isSame = otherPath:getContainer(currentIndex) == self:getContainer(currentIndex)
        isOutOfBounds = currentIndex <= otherPath:getNumComponents() and currentIndex <= self:getNumComponents()
    until isSame or isOutOfBounds

    return currentIndex
end

function Path:getCommonParent(otherPath)
    return self._path[self:_getCommonParentIndex(otherPath)]
end

function Path:_buildRelativeString(otherPath)
    local result = { "." }

    local commonParentIndex = self:_getCommonParentIndex(otherPath)
    for _ = commonParentIndex, self:getNumComponents() do
        table.insert(result, "^")
    end

    for i = commonParentIndex + 1, self:getNumComponents() do
        table.insert(result, tostring(otherPath:getComponent(i)))
    end

    return table.concat(result, ".")
end

function Path:toString(other)
    if other then
        return self:_buildRelativeString(other)
    else
        return self._absolutePath
    end
end

return Path
