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
local EventQueue = require "ItsyScape.Game.RPC.EventQueue"
local State = require "ItsyScape.Game.RPC.State"
local OutgoingEventQueue = require "ItsyScape.Game.RPC.OutgoingEventQueue"
local Property = require "ItsyScape.Game.RPC.Property"
local TypeProvider = require "ItsyScape.Game.RPC.TypeProvider"
local DebugStats = require "ItsyScape.Graphics.DebugStats"
local NGameManager = require "nbunny.gamemanager"
local NProperty = require "nbunny.gamemanager.property"
local NVariant = require "nbunny.gamemanager.variant"

local GameManager = Class()

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
		group = GameManager.PropertyGroup(groupName)
		self.propertyGroups[groupName] = group
	end

	return group
end

function GameManager.Instance:iteratePropertyGroups()
	return pairs(self.propertyGroups)
end

function GameManager.Instance:iterateProperties()
	return ipairs(self.properties)
end

function GameManager.Instance:hasProperty(propertyName)
	return self.properties[propertyName] ~= nil and self.properties[propertyName]:getHasValue()
end

function GameManager.Instance:getProperty(propertyName)
	return self.properties[propertyName]:getValue()
end

function GameManager.Instance:registerProperty(propertyName, property)
	local p = GameManager.Property(self, propertyName, property)

	table.insert(self.properties, p)
	self.properties[propertyName] = p
end

function GameManager.Instance:setProperty(propertyName, ...)
	local property = self.properties[propertyName]
	property:set(propertyName, ...)
end

function GameManager.Instance:pullProperty(propertyName, field, ...)
	local property = self.properties[propertyName]
	property:pull(propertyName, field, ...)
end

function GameManager.Instance:updateProperty(property, force)
	local isDirty = property:update(self.instance)
	if isDirty or force then
		self.gameManager:pushProperty(
			self.interface,
			self.id,
			property:getField(),
			property:getValue())
	end
end

function GameManager.Instance:update(force)
	for _, property in ipairs(self.properties) do
		self.gameManager:getDebugStats():measure(
			string.format("%s::%s::%s", EventQueue.EVENT_TYPE_PROPERTY, self.interface, property:getField()),
			self.updateProperty,
			self,
			property,
			force)
	end
end

GameManager.Property = Class()
function GameManager.Property:new(instance, field, property)
	self.instance = instance
	self.field = field
	self.property = property
	self.hasValue = false
end

function GameManager.Property:getField()
	return self.field
end

function GameManager.Property:getHasValue()
	return self.hasValue
end

function GameManager.Property:getValue()
	return unpack(self.value.arguments, 1, self.n)
end

local function _isEqual(a, b)
	if type(a) ~= type(b) then
		return false
	end

	if type(a) == "table" then
		if getmetatable(a) or getmetatable(b) then
			return a == b
		end

		for k, v in pairs(a) do
			if b[k] == nil or not _isEqual(v, b[k]) then
				return false
			end
		end

		for k in pairs(b) do
			if a[k] == nil then
				return false
			end
		end
		
		return true
	end

	return a == b
end

function GameManager.Property:update(instance)
	self.hasValue = true

	local oldValue = self.value
	self.value = { arguments = { self.property:filter(instance[self.field](instance)) } }
	self.value.n = table.maxn(self.value.arguments)
	
	return not _isEqual(self.value, oldValue)
end

function GameManager.Property:set(instance, value)
	self.hasValue = true
	self.value = value
end

function GameManager.Property:pull(instance, field, e)
	self.hasValue = true
	self.value = e[field]
end

GameManager.PropertyGroup = Class()

function GameManager.PropertyGroup:new(name)
	self.name = name
	self.values = {}
end

function GameManager.PropertyGroup:iterate()
	return ipairs(self.values)
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
				if (isNotBooleanOverride and key[k].value and value and key[k].value < value) and not override then
					outPrioritized = true
				end
			elseif Class.isCompatibleType(argument, Event.KeyArgument) then
				if not State.deepEquals(key[k].value, value) then
					isMatch = false
					break
				end
			elseif Class.isCompatibleType(argument, Event.OverrideKeyArgument) then
				-- Nothing. 'Override' is only used for incoming keys, not stored keys.
			end
		end

		if isMatch then
			return i, outPrioritized and not override
		end
	end

	return nil, nil
end

function GameManager.PropertyGroup:set(key, ...)
	local index, outPrioritized = self:findIndexOfKey(key)
	if not outPrioritized then
		if index then
			self.values[index].key = key
			self.values[index].value = { n = select("#", ... ), arguments = { ... } }
		else
			table.insert(self.values, {
				key = key,
				value = { n = select("#", ... ), arguments = { ... } }
			})
		end

		return true
	end

	return false
end

function GameManager.PropertyGroup:unset(key)
	local index = self:findIndexOfKey(key)
	if index then
		table.remove(self.values, index)
		return true
	end

	return false
end

function GameManager.PropertyGroup:has(key)
	return self:findIndexOfKey(key) ~= nil
end

function GameManager.PropertyGroup:get(key)
	local index, outPrioritized = self:findIndexOfKey(key)
	if index then
		local v = self.values[index].value
		return unpack(v.arguments, 1, v.n)
	end
end

function GameManager:new()
	if NGameManager.fetch() then
		error("can only be one game manager on thread")
	end

	NGameManager.assign(self)

	self.queue = OutgoingEventQueue()

	self.interfaces = {}
	self.interfaceInstances = {}
	self.instances = {}

	self.ticks = 0

	self.debugStats = DebugStats.GlobalDebugStats()
end

function GameManager:getQueue()
	return self.queue
end

function GameManager:getDebugStats()
	return self.debugStats
end

function GameManager:registerInterface(interface, Type)
	local success, result = pcall(require, interface)
	assert(success)
	assert(Class.isType(result))
	assert(Class.isDerived(Type, result))

	self.interfaces[interface] = { type = Type }
	self.interfaceInstances[interface] = {}
end

function GameManager:getInterfaceType(interface)
	return self.interfaces[interface].type
end

function GameManager:process(e)
	if e.type == EventQueue.EVENT_TYPE_CREATE then
		self:processCreate(e)
	elseif e.type == EventQueue.EVENT_TYPE_DESTROY then
		self:processDestroy(e)
	elseif e.type == EventQueue.EVENT_TYPE_CALLBACK then
		self.debugStats:measure(
			string.format("%s::%s::%s::process", e.type, e.interface, e.callback),
			self.processCallback, self, e)
	elseif e.type == EventQueue.EVENT_TYPE_PROPERTY then
		self:processProperty(e)
	elseif e.type == EventQueue.EVENT_TYPE_TICK then
		self:processTick(e)
	end
end

function GameManager:pushCreate(interface, id)
	self.queue:pushCreate(interface, id)
end

function GameManager:processCreate(e)
	-- Nothing.
end

function GameManager:pushDestroy(interface, id)
	self.queue:pushDestroy(interface, id)
end

function GameManager:processDestroy(e)
	-- Nothing.
end

function GameManager:pushCallback(interface, id, callback, key, ...)
	self.queue:pushCallback(interface, id, callback, key, ...)
end

-- This process should be the same client/server.
function GameManager:processCallback(e)
	local instance = self:getInstance(e.interface, e.id)
	if instance then
		local obj = instance:getInstance()
		local event = obj[e.callback]

		if Class.isCompatibleType(event, Callback) or type(event) == "function" then
			event(obj, unpack(e.value.arguments, 1, e.value.n))
		end
	end
end

function GameManager:pushProperty(interface, id, property, ...)
	self.queue:pushProperty(interface, id, property, ...)
end

function GameManager:processProperty(e)
	local instance = self:getInstance(e.interface, e.id)
	if not instance then
		Log.engine("'%s' (ID %d) not found; cannot update property '%s'.", e.interface, e.id, e.property)
	else
		instance:pullProperty(e.property, "value", e)
	end
end

function GameManager:pushTick()
	self.ticks = self.ticks + 1
	self.queue:pushTick(self.ticks)
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
	for i = #self.instances, 1, -1 do
		self.instances[i]:update()
	end
end

function GameManager:getInstance(interface, id)
	local instances = self.interfaces[interface]
	local instance = instances[id]

	return instance
end

function GameManager:iterateInstances(interface)
	return pairs(self.interfaceInstances[interface])
end

function GameManager:newInstance(interface, id, obj)
	local instance = GameManager.Instance(interface, id, obj, self)
	local instances = self.interfaces[interface]

	instances[id] = instance
	table.insert(self.instances, instance)
	self.interfaceInstances[interface][obj] = id

	return instance
end

function GameManager:destroyInstance(interface, id)
	local instances = self.interfaces[interface]
	local instance = instances[id]

	if instance then
		instances[id] = nil
		self.interfaceInstances[interface][instance:getInstance()] = nil

		for i = 1, #self.instances do
			if self.instances[i] == instance then
				table.remove(self.instances, i)
				break
			end
		end
	end
end

-- In setStateForPropertyGroup and unsetStateForPropertyGroup, the first argument
-- from the callback is ignored. The first argument is always the genuine Model-derived
-- instance of the entity, which we don't care about.
function GameManager:_setStateForPropertyGroup(interface, id, event, _, ...)
	local instance = self:getInstance(interface, id)
	if instance then
		local group = instance:getPropertyGroup(event:getGroup())

		local key = event:getKeyFromArguments(...)
		if group:set(key, ...) then
			self:pushCallback(interface, id, event:getCallbackName(), key, ...)
		end
	end
end

function GameManager:setStateForPropertyGroup(interface, id, event, _, ...)
	self.debugStats:measure(
		string.format("%s::%s::%s::set", EventQueue.EVENT_TYPE_CALLBACK, interface, event:getCallbackName()),
		self._setStateForPropertyGroup,
		self,
		interface,
		id,
		event,
		_,
		...)
end

function GameManager:unsetStateForPropertyGroup(interface, id, event, _, ...)
	local instance = self:getInstance(interface, id)
	if instance then
		local group = instance:getPropertyGroup(event:getGroup())

		local key = event:getKeyFromArguments(...)
		if group:unset(key) then
			self:pushCallback(interface, id, event:getCallbackName(), key, ...)
		end
	end
end

function GameManager:setLocalStateForPropertyGroup(interface, id, event, _, ...)
	local instance = self:getInstance(interface, id)
	if instance then
		local group = instance:getPropertyGroup(event:getGroup())

		local key = event:getKeyFromArguments(...)
		group:set(key, ...)
	end
end

function GameManager:_unsetLocalStateForPropertyGroup(interface, id, event, _, ...)
	local instance = self:getInstance(interface, id)
	if instance then
		local group = instance:getPropertyGroup(event:getGroup())

		local key = event:getKeyFromArguments(...)
		group:unset(key)
	end
end

function GameManager:_unsetStateForPropertyGroup(interface, id, event, _, ...)
	self.debugStats:measure(
		string.format("%s::%s::%s::unset", EventQueue.EVENT_TYPE_CALLBACK, interface, event:getCallbackName()),
		self._unsetStateForPropertyGroup,
		self,
		interface,
		id,
		event,
		_,
		...)
end

function GameManager:getStateForPropertyGroup(interface, id, event, _, ...)
	local instance = self:getInstance(interface, id)
	if instance then
		local group = instance:getPropertyGroup(event:getGroup())

		local key = event:getKeyFromArguments(...)
		if group:has(key) then
			return event:getReturnValue(group:get(key))
		end
	end

	return
end

function GameManager:_invokeCallback(interface, id, event, _, ...)
	local key = event:getKeyFromArguments(...)
	self:pushCallback(interface, id, event:getCallbackName(), key, ...)
end

function GameManager:invokeCallback(interface, id, event, _, ...)
	self.debugStats:measure(
		string.format("%s::%s::%s::invoke", EventQueue.EVENT_TYPE_CALLBACK, interface, event:getCallbackName()),
		self._invokeCallback,
		self,
		interface,
		id,
		event,
		_,
		...)
end

function GameManager:hasProperty(interface, id, property)
	local instance = self:getInstance(interface, id)
	return instance ~= nil and instance:hasProperty(property)
end

function GameManager:getProperty(interface, id, property)
	local instance = self:getInstance(interface, id)
	return instance:getProperty(property)
end

function GameManager:registerProperty(interface, id, propertyName, property)
	local instance = self:getInstance(interface, id)
	instance:registerProperty(propertyName, property)
end

return GameManager
