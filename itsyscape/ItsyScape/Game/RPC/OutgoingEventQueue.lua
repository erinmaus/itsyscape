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
local NOutgoingEventQueue = require "nbunny.gamemanager.outgoingeventqueue"

require "nbunny.gamemanager.event"
require "nbunny.gamemanager.variant"

local OutgoingEventQueue = Class()

function OutgoingEventQueue:new()
	self:tick()
end

function OutgoingEventQueue:tick()
	self._handle = NOutgoingEventQueue()
end

function OutgoingEventQueue:pushCreate(interface, id)
	self._handle:push(
		"type", GameManager.QUEUE_EVENT_TYPE_CREATE,
		"interface", interface,
		"id", id)
end

function OutgoingEventQueue:pushDestroy(interface, id)
	self._handle:push(
		"type", GameManager.QUEUE_EVENT_TYPE_DESTROY,
		"interface", interface,
		"id", id)
end

function OutgoingEventQueue:pushCallback(interface, id, callback, ...)
	self._handle:push(
		"type", GameManager.QUEUE_EVENT_TYPE_CALLBACK,
		"interface", interface,
		"id", id,
		"callback", callback,
		"value", self._handle:args(...))
end

function OutgoingEventQueue:pushProperty(interface, id, property, ...)
	self._handle:push(
		"type", GameManager.QUEUE_EVENT_TYPE_CALLBACK,
		"interface", interface,
		"id", id,
		"property", property,
		"value", self._handle:args(...))
end

-- 'e' is a get from an existing EventQueue
function OutgoingEventQueue:pull(e)
	self._handle:pull(e)
end

function OutgoingEventQueue:pushTick(ticks)
	self._handle:push(
		"type", GameManager.QUEUE_EVENT_TYPE_TICK,
		"timestamp", ticks)
end

function OutgoingEventQueue:length()
	return self._handle:length()
end

function OutgoingEventQueue:get(index)
	return self._handle:get(index)
end

function OutgoingEventQueue:getCurrentHandle()
	return self._handle:toLightHandle()
end

return OutgoingEventQueue
