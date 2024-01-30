--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/IncomingEventQueue.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local NEventQueue = require "nbunny.gamemanager.eventqueue"

local IncomingEventQueue = Class()

function IncomingEventQueue:new()
	self._handle = NEventQueue()
end

function IncomingEventQueue:tick(handle)
	self._current = self._handle:createIncomingQueue(handle)
end

function IncomingEventQueue:next()

end

function IncomingEventQueue:pushCreate(interface, id)
	assert(self._current, "no current state")

	self._current:push(
		"type", GameManager.QUEUE_EVENT_TYPE_CREATE,
		"interface", interface,
		"id", id)
end

function IncomingEventQueue:pushDestroy(interface, id)
	self._current:push(
		"type", GameManager.QUEUE_EVENT_TYPE_DESTROY,
		"interface", interface,
		"id", id)
end

function IncomingEventQueue:pushCallback(interface, id, callback, ...)
	self._current:push(
		"type", GameManager.QUEUE_EVENT_TYPE_CALLBACK,
		"interface", interface,
		"id", id,
		"callback", callback,
		"value", self._current:args(...))
end

function IncomingEventQueue:pushProperty(interface, id, property, ...)
	self._current:push(
		"type", GameManager.QUEUE_EVENT_TYPE_CALLBACK,
		"interface", interface,
		"id", id,
		"property", property,
		"value", self._current:args(...))
end

function IncomingEventQueue:pushTick(ticks)
	self._current:push(
		"type", GameManager.QUEUE_EVENT_TYPE_TICK,
		"timestamp", ticks)
end

function IncomingEventQueue:getCurrentHandle()
	return self._current:toLightHandle()
end

function IncomingEventQueue:serialize()
	return self._current:serialize()
end

return IncomingEventQueue
