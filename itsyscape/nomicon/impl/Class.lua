local Class = {}

function Class.isClass(a)
    return Class.getType(a) ~= nil
end

function Class.getType(a)
    a = getmetatable(a) or {}
    a = a.__type or {}

    if a and getmetatable(a) and getmetatable(a).__c == Class then
        return a
    end

    return nil
end

function Class.isDerived(a, b)
    local t = a
    while t ~= nil do
        if t == b then
            return true
        else
            t = getmetatable(t).__parent
        end
    end

    return false
end

local function getType(self)
    return Class.getType(self)
end

local function isType(self, type)
    return self:getType() == type
end

local function isCompatibleType(self, type)
    return Class.isCompatibleType(self, type)
end

local function getDebugInfo(self)
    return self:getType()._DEBUG
end

local Common = {
    getType = getType,
    isType = isType,
    isCompatibleType = isCompatibleType,
    getDebugInfo = getDebugInfo
}

local function __call(self, parent, stack)
    local C = Class

    local Type = { __index = parent or Common, __parent = parent, __c = Class }
    local Class = setmetatable({}, Type)
    local Metatable = { __index = Class, __type = Class }
    Class._METATABLE = Metatable
    Class._PARENT = parent or false
    Class._DEBUG = {}

    do
        local debug = require "debug"

        local info = debug.getinfo(2 + (stack or 0), "Sl")
        if info then
            local shortClassName = info.source:match("^.*/(.*/.*).lua$") or info.source
            local lineNumber = info.currentline

            Class._DEBUG.lineNumber = lineNumber
            Class._DEBUG.filename = info.source
            Class._DEBUG.shortName = string.format("%s:%d", shortClassName, lineNumber)
        end
    end

    if parent then
        for k, v in pairs(parent._METATABLE) do
            if type(k) == 'string' and type(v) == 'function' then
                Metatable[k] = v
            end
        end
    end

    function Type.__call(_self, ...)
        local result = setmetatable({}, Metatable)

        if Class.new then
            Class.new(result, ...)
        end

        return result
    end

    return Class, Metatable
end

return setmetatable(Class, { __call = __call })
