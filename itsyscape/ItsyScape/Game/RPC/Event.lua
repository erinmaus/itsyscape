--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/Event.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Event = Class()

Event.BaseFilter = Class()
Event.MapLayerFilter = Class(Event.BaseFilter)

Event.BaseArgument = Class()
function Event.BaseArgument:new(parameter, isFilter, isOptional)
	self.parameter = parameter
	self.isFilter = isFilter or false
	self.isOptional = (isOptional == nil) and false or isOptional
end

function Event.BaseArgument:getParameter()
	return self.parameter
end

function Event.BaseArgument:getIsFilter()
	return self.isFilter
end

function Event.BaseArgument:getIsOptional()
	return self.isOptional
end

Event.KeyArgument = Class(Event.BaseArgument)
Event.Argument = Class(Event.BaseArgument)
Event.SortedKeyArgument = Class(Event.BaseArgument)
Event.OverrideKeyArgument = Class(Event.BaseArgument)
Event.TimeArgument = Class(Event.BaseArgument)
Event.Arguments = Class(Event.BaseArgument)
Event.Return = Class(Event.BaseArgument)

Event.BaseCall = Class()
function Event.BaseCall:new(...)
	self.arguments = { ... }
end

function Event.BaseCall:getNumArguments()
	return #self.arguments
end

function Event.BaseCall:getArgument(index)
	return self.arguments[index]
end

function Event.BaseCall:getKeyFromArguments(...)
	local key = {}
	for i = 1, #self.arguments do
		local argument = self.arguments[i]
		if Class.isCompatibleType(argument, Event.KeyArgument) or
		   Class.isCompatibleType(argument, Event.SortedKeyArgument) or
		   Class.isCompatibleType(argument, Event.OverrideKeyArgument) or
		   argument:getIsFilter()
		then
			key[argument:getParameter()] = {
				value = select(i, ...),
				argument = argument
			}
		end
	end
	return key
end

function Event.BaseCall:getReturnValue(...)
	for i = 1, #self.arguments do
		local argument = self.arguments[i]
		if Class.isCompatibleType(argument, Event.Return) then
			return select(i, ...)
		end
	end

	return ...
end

function Event.BaseCall:link(callbackName, ...)
	self.callbackName = callbackName
	self.callbackArguments = { n = select('#', ...), ... }
end

function Event.BaseCall:getCallbackName()
	if not self.callbackName then
		Log.error("No callback name.")
	end

	return self.callbackName
end

function Event.BaseCall:getCallbackArguments()
	return self.callbackArguments
end

Event.Set = Class(Event.BaseCall)
function Event.Set:new(group, ...)
	Event.BaseCall.new(self, ...)
	self.group = group
end

function Event.Set:getGroup()
	return self.group
end

Event.Unset = Class(Event.BaseCall)
function Event.Unset:new(group, ...)
	Event.BaseCall.new(self, ...)
	self.group = group
end

function Event.Unset:getGroup()
	return self.group
end

Event.Get = Class(Event.BaseCall)
function Event.Get:new(group, ...)
	Event.BaseCall.new(self, ...)
	self.group = group
end

function Event.Get:getGroup()
	return self.group
end

Event.ServerToClientRPC = Class(Event.BaseCall)
Event.ClientToServerRPC = Class(Event.BaseCall)

Event.Create = Class(Event.BaseCall)
function Event.Create:new(proxy, func, ...)
	Event.BaseCall.new(self, ...)
	self.proxy = proxy
	self.func = func
end

function Event.Create:getProxy()
	return self.proxy
end

function Event.Create:getFunc()
	return self.func
end

Event.Destroy = Class(Event.BaseCall)
function Event.Destroy:new(proxy, func, ...)
	Event.BaseCall.new(self, ...)
	self.proxy = proxy
	self.func = func
end

function Event.Destroy:getProxy()
	return self.proxy
end

function Event.Destroy:getFunc()
	return self.func
end

return Event
