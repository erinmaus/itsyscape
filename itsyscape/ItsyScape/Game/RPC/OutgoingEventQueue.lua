--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/OutgoingEventQueue.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local EventQueue = require "ItsyScape.Game.RPC.EventQueue"
local NEventQueue = require "nbunny.gamemanager.eventqueue"
local NVariant = require "nbunny.gamemanager.variant"

local OutgoingEventQueue = Class()

function OutgoingEventQueue:new()
	self._handle = NEventQueue()
	self._popEvent = NVariant()
	self._getEvent = NVariant()
	self.timestamp = 0
end

function OutgoingEventQueue:tick()
	self._handle:clear()
end

function OutgoingEventQueue:_getTimestamp()
	self.timestamp = self.timestamp + 1
	return self.timestamp
end

function OutgoingEventQueue:pushCreate(interface, id)
	self._handle:push(
		"__timestamp", self:_getTimestamp(),
		"type", EventQueue.EVENT_TYPE_CREATE,
		"interface", interface,
		"id", id)
end

function OutgoingEventQueue:pushDestroy(interface, id)
	self._handle:push(
		"__timestamp", self:_getTimestamp(),
		"type", EventQueue.EVENT_TYPE_DESTROY,
		"interface", interface,
		"id", id)
end

function OutgoingEventQueue:pushCallback(interface, id, callback, key, ...)
	self._handle:push(
		"__timestamp", self:_getTimestamp(),
		"type", EventQueue.EVENT_TYPE_CALLBACK,
		"interface", interface,
		"id", id,
		"callback", callback,
		"key", key,
		"value", NVariant.fromArguments(...))
end

function OutgoingEventQueue:pushProperty(interface, id, property, ...)
	self._handle:push(
		"__timestamp", self:_getTimestamp(),
		"type", EventQueue.EVENT_TYPE_PROPERTY,
		"interface", interface,
		"id", id,
		"property", property,
		"value", NVariant.fromArguments(...))
end

function OutgoingEventQueue:pushTick(ticks)
	self._handle:push(
		"__timestamp", self:_getTimestamp(),
		"type", EventQueue.EVENT_TYPE_TICK,
		"ticks", ticks)
end

function OutgoingEventQueue:pop()
	self._handle:pop(self._popEvent)
	return self._popEvent
end

-- 'e' is a get from an existing EventQueue
function OutgoingEventQueue:pull(e)
	self._handle:pull(e)
end

function OutgoingEventQueue:length()
	return self._handle:length()
end

function OutgoingEventQueue:get(index)
	self._handle:get(math.max(index - 1, 0), self._getEvent)
	return self._getEvent
end

function OutgoingEventQueue:toBuffer()
	return self._handle:toBuffer()
end

return OutgoingEventQueue
