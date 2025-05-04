--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/OutgoingEventQueue.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local buffer = require "string.buffer"
local Class = require "ItsyScape.Common.Class"
local EventQueue = require "ItsyScape.Game.RPC.EventQueue"
local NEventQueue = require "nbunny.gamemanager.eventqueue"
local NVariant = require "nbunny.gamemanager.variant"

local OutgoingEventQueue = Class()

OutgoingEventQueue.INSTANCE_TYPES = {
	"ItsyScape.Game.Model.Actor",
	"ItsyScape.Game.Model.Game",
	"ItsyScape.Game.Model.Player",
	"ItsyScape.Game.Model.Prop",
	"ItsyScape.Game.Model.Stage",
	"ItsyScape.Game.Model.UI"
}

OutgoingEventQueue.IGNORED_FIELDS = {
	["key"] = true
}

function OutgoingEventQueue:new()
	self.n = 0
	self.queue = {}

	self.serializedQueue = EventQueue.newBuffer()
	self.timestamp = 0
end

function OutgoingEventQueue:tick()
	self.n = 0
	self.serializedQueue:reset()
end

function OutgoingEventQueue:_getTimestamp()
	self.timestamp = self.timestamp + 1
	return self.timestamp
end

function OutgoingEventQueue:_newEvent()
	self.n = self.n + 1

	local e
	if #self.queue < self.n then
		e = { __serialized = {} }
		self.queue[self.n] = e
	else
		e = self.queue[self.n]
		local s = e.__serialized
		table.clear(e)
		table.clear(s)

		e.__serialized = s
	end

	return e
end


function OutgoingEventQueue:push(...)
	return self:_push(self:_newEvent(), ...)
end

function OutgoingEventQueue:_marshalValue(value)
	if not Class.isClass(value) then
		return value
	end

	for _, instanceTypeName in ipairs(self.INSTANCE_TYPES) do
		if Class.isCompatibleType(value, require(instanceTypeName)) then
			return { __interface = instanceTypeName, __id = value.getID and value:getID() or 0 }
		end
	end

	return value
end

function OutgoingEventQueue:_push(e, field, value, ...)
	if field then
		e[field] = value

		if not self.IGNORED_FIELDS[field] then
			e.__serialized[field] = value
		end

		if type(value) == "table" and field == "value" then
			for i = 1, value.n do
				value.arguments[i] = self:_marshalValue(value.arguments[i])
			end
		end
		
		return self:_push(e, ...)
	end

	return self.serializedQueue:encode(e.__serialized)
end

function OutgoingEventQueue:pushCreate(interface, id)
	self:push(
		"__timestamp", self:_getTimestamp(),
		"type", EventQueue.EVENT_TYPE_CREATE,
		"interface", interface,
		"id", id)
end

function OutgoingEventQueue:pushDestroy(interface, id)
	self:push(
		"__timestamp", self:_getTimestamp(),
		"type", EventQueue.EVENT_TYPE_DESTROY,
		"interface", interface,
		"id", id)
end

function OutgoingEventQueue:pushCallback(interface, id, callback, key, ...)
	self:push(
		"__timestamp", self:_getTimestamp(),
		"type", EventQueue.EVENT_TYPE_CALLBACK,
		"interface", interface,
		"id", id,
		"callback", callback,
		"key", key,
		"value", { n = select("#", ...), arguments = { ... } })
end

function OutgoingEventQueue:pushProperty(interface, id, property, ...)
	self:push(
		"__timestamp", self:_getTimestamp(),
		"type", EventQueue.EVENT_TYPE_PROPERTY,
		"interface", interface,
		"id", id,
		"property", property,
		"value", { n = select("#", ...), arguments = { ... } })
end

function OutgoingEventQueue:pushTick(ticks)
	self:push(
		"__timestamp", self:_getTimestamp(),
		"type", EventQueue.EVENT_TYPE_TICK,
		"ticks", ticks)
end

function OutgoingEventQueue:pop()
	if self.n <= 0 then
		return nil
	end

	local e = self.queue[self.n]
	self.n = self.n - 1

	return e
end

-- 'e' is a get from an existing EventQueue
function OutgoingEventQueue:pull(otherE)
	local e = self:_newEvent()
	for k, v in pairs(otherE) do
		e[k] = v
	end

	self.serializedQueue:encode(otherE)
end

function OutgoingEventQueue:length()
	return self.n
end

function OutgoingEventQueue:get(index)
	if index > self.n or index <= 0 then
		return nil
	end

	return self.queue[index]
end

function OutgoingEventQueue:toBuffer()
	return self.serializedQueue:tostring()
end

return OutgoingEventQueue
