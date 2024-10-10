--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/EventQueue.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local buffer = require "string.buffer"

local EventQueue = {}
EventQueue.EVENT_TYPE_CREATE   = "create"
EventQueue.EVENT_TYPE_DESTROY  = "destroy"
EventQueue.EVENT_TYPE_CALLBACK = "callback"
EventQueue.EVENT_TYPE_PROPERTY = "property"
EventQueue.EVENT_TYPE_TICK     = "tick"

function EventQueue.newBuffer()
	local metatables = {
		require("ItsyScape.Common.Math.Ray")._METATABLE,
		require("ItsyScape.Common.Math.Vector")._METATABLE,
		require("ItsyScape.Common.Math.Quaternion")._METATABLE,
		require("ItsyScape.Game.CacheRef")._METATABLE,
		require("ItsyScape.Game.PlayerStorage")._METATABLE,
		require("ItsyScape.Game.PlayerStorage").Section._METATABLE,
		require("ItsyScape.Game.RPC.Event")._METATABLE,
		require("ItsyScape.Graphics.Color")._METATABLE,
		require("ItsyScape.World.Map")._METATABLE,
		require("ItsyScape.World.Tile")._METATABLE,
		require("ItsyScape.Game.Model.Actor")._METATABLE,
		require("ItsyScape.Game.Model.Game")._METATABLE,
		require("ItsyScape.Game.Model.Player")._METATABLE,
		require("ItsyScape.Game.Model.Prop")._METATABLE,
		require("ItsyScape.Game.Model.Stage")._METATABLE,
		require("ItsyScape.Game.Model.UI")._METATABLE
	}

	local commonKeys = {
		"__timestamp",
		"__interface",
		"__id",
		"type",
		"interface",
		"id",
		"callback",
		"key",
		"property",
		"value",
		"ticks"
	}

    return buffer.new({ metatable = metatables, dict = commonKeys })
end

return EventQueue
