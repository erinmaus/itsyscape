--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/GameManager.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Game = require "ItsyScape.Game.Model.Game"
local Actor = require "ItsyScape.Game.Model.Actor"
local Player = require "ItsyScape.Game.Model.Player"
local Prop = require "ItsyScape.Game.Model.Prop"
local Stage = require "ItsyScape.Game.Model.Stage"
local UI = require "ItsyScape.Game.Model.UI"
local Event = require "ItsyScape.Game.RPC.Event"
local State = require "ItsyScape.Game.RPC.State"
local Property = require "ItsyScape.Game.RPC.Property"
local TypeProvider = require "ItsyScape.Game.RPC.TypeProvider"

local GameManager = Class()

GameManager.QUEUE_EVENT_TYPE_CREATE   = "create"
GameManager.QUEUE_EVENT_TYPE_DESTROY  = "destroy"
GameManager.QUEUE_EVENT_TYPE_CALLBACK = "callback"
GameManager.QUEUE_EVENT_TYPE_PROPERTY = "property"
GameManager.QUEUE_EVENT_TYPE_TICK     = "tick"

GameManager.Instance = Class()
function GameManager.Instance:new(interface, id, instance, gameManager)
	self.id = id
	self.interface = interface
	self.instance = instance
	self.gameManager = gameManager

	self.properties = {}
	self.propertyGroups = {}
end

function GameManager.Instance:getID()
	return self.id
end

function GameManager.Instance:getInterface()
	return self.interface
end

function GameManager.Instance:getInstance()
	return self.instance
end

function GameManager.Instance:getGameManager()
	return self.gameManager
end

function GameManager.Instance:getPropertyGroup(groupName)
	local group = self.propertyGroups[groupName]
	if not group then
		group = GameManager.PropertyGroup()
		self.propertyGroups[groupName] = group
	end

	return group
end

function GameManager.Instance:getProperty(propertyName)
	return self.properties[propertyName]:getValue()
end

function GameManager.Instance:registerProperty(propertyName, property)
	local p = GameManager.Property(propertyName, property)

	table.insert(self.properties, p)
	self.properties[propertyName] = p
end

function GameManager.Instance:setProperty(propertyName, value)
	local property = self.properties[propertyName]
	property:set(propertyName, value)
end

local PROPS = 0
function GameManager.Instance:update()
	for i = 1, #self.properties do
		PROPS = PROPS + 1
		local property = self.properties[i]
		local isDirty = property:update(self.instance, self.gameManager)
		if isDirty then
			self.gameManager:pushProperty(
				self.interface,
				self.id,
				property:getField(),
				property:getValue())
		end
	end
end

GameManager.Property = Class()
function GameManager.Property:new(field, filter)
	self.field = field
	self.filter = filter
end

function GameManager.Property:getField()
	return self.field
end

function GameManager.Property:getValue()
	return self.currentValue
end

function GameManager.Property:update(instance, gameManager)
	local getFunc = instance[self.field]
	if not getFunc then
		Log.error("Unknown field: %s", self.field)
	end

	local newValue = gameManager:getArgs(self.filter:filter(getFunc(instance)))

	local isDirty = true
	self.currentValue = newValue

	return isDirty
end

function GameManager.Property:set(instance, newValue)
	self.currentValue = newValue
end

GameManager.PropertyGroup = Class()

function GameManager.PropertyGroup:new()
	self.values = {}
end

function GameManager.PropertyGroup:findIndexOfKey(key)
	local override = false
	for _, v in pairs(key) do
		if Class.isCompatibleType(v.argument, Event.OverrideKeyArgument) and v.value then
			override = true
			break
		end
	end

	for i = 1, #self.values do
		local v = self.values[i]

		local isMatch = true
		local outPrioritized = false
		for k, v in pairs(v.key) do
			local value = v.value
			local argument = v.argument

			if Class.isCompatibleType(argument, Event.SortedKeyArgument) then
				local isNotBooleanOverride = type(value) == type(key[k].value) and type(value) ~= "boolean"
				if (isNotBooleanOverride and key[k].value > value) and not override then
					isMatch = false
					outPrioritized = true
					break
				end
			elseif Class.isCompatibleType(argument, Event.KeyArgument) then
				if not State.deepEquals(key[k].value, value) then
					isMatch = false
					break
				end
			elseif Class.isCompatibleType(argument, Event.OverrideKeyArgument) then
				-- Nothing. 'Override' is only used for incoming keys, not stored keys.
			else
				Log.error("Unhandled key argument type: '%s'", argument:getDebugInfo().shortName)

				isMatch = false
				break
			end
		end

		if isMatch then
			return i, outPrioritized
		end
	end

	return nil, nil
end

function GameManager.PropertyGroup:set(key, values)
	local index, outPrioritized = self:findIndexOfKey(key)
	if index then
		self.values[index].value = values
		return true
	elseif not outPrioritized then
		table.insert(self.values, {
			key = key,
			value = values
		})
		return true
	end

	return false
end

function GameManager.PropertyGroup:unset(key, values)
	local index = self:findIndexOfKey(key)
	if index then
		table.remove(self.values, index)
		return true
	end

	return false
end

function GameManager.PropertyGroup:get(key)
	local index, outPrioritized = self:findIndexOfKey(key)
	if index then
		return self.values[index].value
	end
end

function GameManager:new()
	self.state = State()

	self.queue = {}

	self.interfaces = {}
	self.instances = {}

	self.state:registerTypeProvider("ItsyScape.Common.Math.Quaternion", TypeProvider.Quaternion())
	self.state:registerTypeProvider("ItsyScape.Common.Math.Ray", TypeProvider.Ray())
	self.state:registerTypeProvider("ItsyScape.Common.Math.Vector", TypeProvider.Vector())
	self.state:registerTypeProvider("ItsyScape.Game.CacheRef", TypeProvider.CacheRef())
	self.state:registerTypeProvider("ItsyScape.Game.PlayerStorage", TypeProvider.PlayerStorage())
	self.state:registerTypeProvider("ItsyScape.Graphics.Color", TypeProvider.Color())
	self.state:registerTypeProvider("ItsyScape.Graphics.Decoration", TypeProvider.Decoration())
	self.state:registerTypeProvider("ItsyScape.World.Map", TypeProvider.Map())
	self.state:registerTypeProvider("ItsyScape.World.Tile", TypeProvider.Tile())
end

function GameManager:getState()
	return self.state
end

function GameManager:registerInterface(interface, Type)
	local success, result = pcall(require, interface)
	assert(success)
	assert(Class.isType(result))
	assert(Class.isDerived(Type, result))

	self.interfaces[interface] = {
		type = Type
	}
end

function GameManager:getInterfaceType(interface)
	return self.interfaces[interface].type
end

function GameManager:push(e)
	Class.ABSTRACT()
end

function GameManager:process(e)
	if e.type == GameManager.QUEUE_EVENT_TYPE_CREATE then
		self:processCreate(e)
	elseif e.type == GameManager.QUEUE_EVENT_TYPE_DESTROY then
		self:processDestroy(e)
	elseif e.type == GameManager.QUEUE_EVENT_TYPE_CALLBACK then
		self:processCallback(e)
	elseif e.type == GameManager.QUEUE_EVENT_TYPE_PROPERTY then
		self:processProperty(e)
	elseif e.type == GameManager.QUEUE_EVENT_TYPE_TICK then
		self:processTick(e)
	end
end

function GameManager:pushCreate(interface, id)
	local event = {
		type = GameManager.QUEUE_EVENT_TYPE_CREATE,
		interface = interface,
		id = id
	}

	self:push(event)
end

function GameManager:processCreate(e)
	-- Nothing.
end

function GameManager:pushDestroy(interface, id)
	local event = {
		type = GameManager.QUEUE_EVENT_TYPE_DESTROY,
		interface = interface,
		id = id
	}

	self:push(event)
end

function GameManager:processDestroy(e)
	-- Nothing.
end

function GameManager:pushCallback(interface, id, callback, args)
	local event = {
		type = GameManager.QUEUE_EVENT_TYPE_CALLBACK,
		interface = interface,
		id = id,
		callback = callback,
		value = args
	}

	self:push(event)
end

-- This process should be the same client/server.
function GameManager:processCallback(e)
	local instance = self:getInstance(e.interface, e.id)
	if instance then
		local obj = instance:getInstance()
		local event = obj[e.callback]

		if Class.isCompatibleType(event, Callback) or type(event) == "function" then
			local args = self.state:deserialize(e.value)
			event(obj, unpack(args, 1, table.maxn(args)))
		end
	end
end

function GameManager:pushProperty(interface, id, property, args)
	local event = {
		type = GameManager.QUEUE_EVENT_TYPE_PROPERTY,
		interface = interface,
		id = id,
		property = property,
		value = args
	}

	self:push(event)
end

function GameManager:processProperty(e)
	local instance = self:getInstance(e.interface, e.id)
	instance:setProperty(e.property, e.value)
end

function GameManager:pushTick()
	local event = {
		type = GameManager.QUEUE_EVENT_TYPE_TICK
	}

	self:push(event)
end

function GameManager:processTick(e)
	-- Nothing.
end

function GameManager:send()
	Class.ABSTRACT()
end

function GameManager:receive()
	Class.ABSTRACT()
end

function GameManager:update()
	for i = 1, #self.instances do
		self.instances[i]:update()
	end
end

function GameManager:getArgs(...)
	local args = { ... }
	return self.state:serialize(args)
end

function GameManager:getInstance(interface, id)
	local instances = self.interfaces[interface]
	local instance = instances[id]

	return instance
end

function GameManager:iterateInstances(interface)
	local instances = self.interfaces[interface]

	local current = nil
	return function()
		current = next(instances, current)
		while type(current) ~= "number" and type(current) ~= "nil" do
			current = next(instances, current)
		end

		return current and instances[current]:getInstance()
	end
end

function GameManager:newInstance(interface, id, obj)
	local instance = GameManager.Instance(interface, id, obj, self)
	local instances = self.interfaces[interface]

	instances[id] = instance
	table.insert(self.instances, instance)

	self:pushCreate(interface, id)
	return instance
end

function GameManager:destroyInstance(interface, id)
	local instances = self.interfaces[interface]
	local instance = instances[id]

	instances[id] = nil

	for i = 1, #self.instances do
		if self.instances[i] == instance then
			table.remove(self.instances, i)
			break
		end
	end

	self:pushDestroy(interface, id)
end

-- In setStateForPropertyGroup and unsetStateForPropertyGroup, the first argument
-- from the callback is ignored. The first argument is always the genuine Model-derived
-- instance of the entity, which we don't care about.
function GameManager:setStateForPropertyGroup(interface, id, event, _, ...)
	local instance = self:getInstance(interface, id)
	if instance then
		local group = instance:getPropertyGroup(event:getGroup())

		local key = event:getKeyFromArguments(...)
		local args = self:getArgs(...)
		if group:set(key, args) then
			self:pushCallback(interface, id, event:getCallbackName(), args)
		end
	end
end

function GameManager:unsetStateForPropertyGroup(interface, id, event, _, ...)
	local instance = self:getInstance(interface, id)
	if instance then
		local group = instance:getPropertyGroup(event:getGroup())

		local key = event:getKeyFromArguments(...)
		local args = self:getArgs(...)
		if group:unset(key, args) then
			self:pushCallback(interface, id, event:getCallbackName(), args)
		end
	end
end

function GameManager:setLocalStateForPropertyGroup(interface, id, event, _, ...)
	local instance = self:getInstance(interface, id)
	if instance then
		local group = instance:getPropertyGroup(event:getGroup())

		local key = event:getKeyFromArguments(...)
		local args = self:getArgs(...)
		group:set(key, args)
	end
end

function GameManager:unsetLocalStateForPropertyGroup(interface, id, event, _, ...)
	local instance = self:getInstance(interface, id)
	if instance then
		local group = instance:getPropertyGroup(event:getGroup())

		local key = event:getKeyFromArguments(...)
		local args = self:getArgs(...)
		group:unset(key, args)
	end
end

function GameManager:getStateForPropertyGroup(interface, id, event, _, ...)
	local instance = self:getInstance(interface, id)
	if instance then
		local group = instance:getPropertyGroup(event:getGroup())

		local key = event:getKeyFromArguments(...)
		local args = group:get(key)
		if args then
			local args = self.state:deserialize(args)
			return event:getReturnValue(unpack(args, 1, table.maxn(args)))
		else
			return
		end
	end
end

function GameManager:invokeCallback(interface, id, event, _, ...)
	local args = self:getArgs(...)
	self:pushCallback(interface, id, event:getCallbackName(), args)
end

function GameManager:getProperty(interface, id, property)
	local instance = self:getInstance(interface, id)
	local args = instance:getProperty(property)
	if args then
		return self.state:deserialize(args)
	else
		return {}
	end
end

function GameManager:registerProperty(interface, id, propertyName, property)
	local instance = self:getInstance(interface, id)
	instance:registerProperty(propertyName, property)
end

return GameManager
