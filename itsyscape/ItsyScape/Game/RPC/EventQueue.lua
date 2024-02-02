--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/EventQueue.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local EventQueue = {}

EventQueue.EVENT_TYPE_CREATE   = "create"
EventQueue.EVENT_TYPE_DESTROY  = "destroy"
EventQueue.EVENT_TYPE_CALLBACK = "callback"
EventQueue.EVENT_TYPE_PROPERTY = "property"
EventQueue.EVENT_TYPE_TICK     = "tick"

return EventQueue
