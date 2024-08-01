local PATH = (...):gsub("%.[^%.]+$", "")
local Class = require(PATH .. "Class")
local Utility = require(PATH .. "Utility")
local Value = require(PATH .. "Value")

local GlobalVariables = Class()
GlobalVariables.ANY = "*"

local function __index(self, key)
    local metatable = getmetatable(self)
    return metatable._variables[key] or (metatable._parent and metatable._parent[key])
end

local function __newindex(self, key, value)
    local metatable = getmetatable(self)
    
    local listeners = metatable._onChange[key] or metatable._onChange[""]
    if listeners ~= nil then
        local previousValue = self._variables[key] or Value.VOID

        for _, listener in ipairs(listeners) do
            if listeners == metatable._onChange[GlobalVariables.ANY] then
                listener.args[listener.n + 1] = key
                listeners.args[listener.n + 2] = listener.marshal and value:getValue() or value
                listeners.args[listener.n + 3] = listener.marshal and previousValue:getValue() or previousValue
                listener.func((table.unpack or unpack)(listener.args, 1, listener.n + 3))
            else
                listeners.args[listener.n + 1] = listener.marshal and value:getValue() or value
                listeners.args[listener.n + 2] = listener.marshal and previousValue:getValue() or previousValue
                listener.func((table.unpack or unpack)(listener.args, 1, listener.n + 2))
            end
        end
    end

    metatable._variables[key] = value
end

function GlobalVariables:new(parent)
    self._parent = parent
    self._variables = {}
    self._onChange = { [GlobalVariables.ANY] = {} }
    self._proxy = setmetatable({}, {
        _variables = self._variables,
        _onChange = self._onChange,
        _parent = parent,
        __index = __index,
        __newindex = __newindex
    })
end

function GlobalVariables:getParent()
    return self._parent
end

function GlobalVariables:listen(variableName, func, marshal, ...)
    variableName = variableName or GlobalVariables.ANY

    local listeners = self._onChange[variableName]
    if not listeners then
        listeners = {}
        self._onChange[variableName] = listeners
    end

    table.insert(self._onChange[variableName], {
        args = { ... },
        n = select("#", ...),
        marshal = marshal == nil and true or not not marshal,
        func = func
    })
end

function GlobalVariables:remove(variableName, func)
    local listeners = self._onChange[variableName]
    if not listeners then
        return
    end

    if not func then
        if variableName == GlobalVariables.ANY then
            Utility.clearTable(listeners)
        else
            self._onChange[variableName] = nil
        end

        return
    end

    for i = #listeners, 1, -1 do
        if listeners[i].func == func then
            table.remove(listeners[i].func, i)
        end
    end
end

function GlobalVariables:clearAll()
    for variableName in pairs(self._onChange) do
        if variableName ~= GlobalVariables.ANY then
            self._onChange[variableName] = nil
        end
    end
end

function GlobalVariables:reset()
    Utility.clearTable(self._variables)
end

function GlobalVariables:get(key)
    return self._proxy[key]
end

function GlobalVariables:set(key, value, fireObservers)
    -- The default should be "true", so only skip observers if fireObservers is explicitly false
    if fireObservers == false then
        self._variables[key] = value
    else
        self._proxy[key] = value
    end
end

function GlobalVariables:iterate()
    return pairs(self._variables)
end

return GlobalVariables
