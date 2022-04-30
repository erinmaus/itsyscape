--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/Proxy.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Event = require "ItsyScape.Game.RPC.Event"
local State = require "ItsyScape.Game.RPC.State"
local Property = require "ItsyScape.Game.RPC.Property"

local Proxy = Class()

Proxy.Field = Class()

function Proxy.Field:new(key, value)
	self.key = key
	self.value = value
end

function Proxy.Field:getKey()
	return self.key
end

function Proxy.Field:getValue()
	return self.value
end

function Proxy:new(definition)
	self.fields = {}
	self.events = {}
	self.properties = {}
	self.groups = {}

	for key, value in pairs(definition) do
		if Class.isCompatibleType(value, Property) then
			self:createProperty(key, value)
		elseif Class.isCompatibleType(value, Event.BaseCall) then
			self:createEvent(key, value)
		end
	end

	self.defition = definition
end

function Proxy:getDefinition()
	return self.defition
end

function Proxy:createProperty(key, property)
	assert(self.fields[key] == nil)

	self.fields[key] = true
	table.insert(self.properties, Proxy.Field(key, property))
end

function Proxy:createEvent(key, event)
	assert(self.fields[key] == nil)

	self.fields[key] = true
	table.insert(self.events, Proxy.Field(key, event))
end

function Proxy:wrapServer(interface, id, instance, gameManager)
	for i = 1, #self.properties do
		local propertyName = self.properties[i]:getKey()
		local property = self.properties[i]:getValue()

		gameManager:registerProperty(interface, id, propertyName, property)
	end

	local groups = {}
	for i = 1, #self.events do
		local key = self.events[i]:getKey()
		local event = self.events[i]:getValue()

		if Class.isCompatibleType(event, Event.Set) then
			instance[event:getCallbackName()]:register(gameManager.setStateForPropertyGroup, gameManager, interface, id, event)
		elseif Class.isCompatibleType(event, Event.Unset) then
			instance[event:getCallbackName()]:register(gameManager.unsetStateForPropertyGroup, gameManager, interface, id, event)
		elseif Class.isCompatibleType(event, Event.ServerToClientRPC) then
			instance[event:getCallbackName()]:register(gameManager.invokeCallback, gameManager, interface, id, event)
		elseif Class.isCompatibleType(event, Event.ClientToServerRPC) then
			Log.debug("Ignoring event '%s' of type 'ClientToServerRPC'; wrapping for server, not client.")
		elseif Class.isCompatibleType(event, Event.Create) then
			instance[event:getCallbackName()]:register(event:getFunc(), event, gameManager)
		elseif Class.isCompatibleType(event, Event.Destroy) then
			instance[event:getCallbackName()]:register(event:getFunc(), event, gameManager)
		end
	end
end

function Proxy:wrapClient(interface, id, instance, gameManager)
	for i = 1, #self.properties do
		local propertyName = self.properties[i]:getKey()
		local property = self.properties[i]:getValue()

		gameManager:registerProperty(interface, id, propertyName, property)

		instance[propertyName] = function()
			local p = gameManager:getProperty(interface, id, propertyName)
			return unpack(p, 1, p.n)
		end
	end

	for i = 1, #self.events do
		local name = self.events[i]:getKey()
		local event = self.events[i]:getValue()

		if Class.isCompatibleType(event, Event.ClientToServerRPC) then
			instance[name] = function(...)
				event:link(name)
				gameManager:invokeCallback(interface, id, event, ...)
			end
		elseif Class.isCompatibleType(event, Event.Set) then
			instance[event:getCallbackName()]:register(gameManager.setLocalStateForPropertyGroup, gameManager, interface, id, event)
		elseif Class.isCompatibleType(event, Event.Unset) then
			instance[event:getCallbackName()]:register(gameManager.unsetLocalStateForPropertyGroup, gameManager, interface, id, event)
		elseif Class.isCompatibleType(event, Event.Get) then
			instance[name] = function(...)
				return gameManager:getStateForPropertyGroup(interface, id, event, ...)
			end
		end
	end
end

return Proxy
