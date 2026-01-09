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
local NPooledBuffer = require "nbunny.pooledbuffer"

local EventQueue = {}
EventQueue.EVENT_TYPE_CREATE   = "create"
EventQueue.EVENT_TYPE_DESTROY  = "destroy"
EventQueue.EVENT_TYPE_CALLBACK = "callback"
EventQueue.EVENT_TYPE_PROPERTY = "property"
EventQueue.EVENT_TYPE_TICK     = "tick"

EventQueue.METATABLE = {
	require("ItsyScape.Common.Math.Ray")._METATABLE,
	require("ItsyScape.Common.Math.Vector")._METATABLE,
	require("ItsyScape.Common.Math.Quaternion")._METATABLE,
	require("ItsyScape.Game.CacheRef")._METATABLE,
	require("ItsyScape.Game.PlayerStorage")._METATABLE,
	require("ItsyScape.Game.PlayerStorage").Section._METATABLE,
	require("ItsyScape.Game.RPC.Event")._METATABLE,
	require("ItsyScape.Graphics.Color")._METATABLE,
	require("ItsyScape.Graphics.DecorationMaterial")._METATABLE,
	require("ItsyScape.World.Map")._METATABLE,
	require("ItsyScape.World.Tile")._METATABLE
}

EventQueue.PROXY = {
	[require("ItsyScape.Game.RemoteModel.Actor")._METATABLE] = "ItsyScape.Game.Model.Actor",
	[require("ItsyScape.Game.RemoteModel.Game")._METATABLE] = "ItsyScape.Game.Model.Game",
	[require("ItsyScape.Game.RemoteModel.Player")._METATABLE] = "ItsyScape.Game.Model.Player",
	[require("ItsyScape.Game.RemoteModel.Prop")._METATABLE] = "ItsyScape.Game.Model.Prop",
	[require("ItsyScape.Game.RemoteModel.Stage")._METATABLE] = "ItsyScape.Game.Model.Stage",
	[require("ItsyScape.Game.RemoteModel.UI")._METATABLE] = "ItsyScape.Game.Model.UI",

	[require("ItsyScape.Game.LocalModel.Actor")._METATABLE] = "ItsyScape.Game.Model.Actor",
	[require("ItsyScape.Game.LocalModel.Game")._METATABLE] = "ItsyScape.Game.Model.Game",
	[require("ItsyScape.Game.LocalModel.Player")._METATABLE] = "ItsyScape.Game.Model.Player",
	[require("ItsyScape.Game.LocalModel.Prop")._METATABLE] = "ItsyScape.Game.Model.Prop",
	[require("ItsyScape.Game.LocalModel.Stage")._METATABLE] = "ItsyScape.Game.Model.Stage",
	[require("ItsyScape.Game.LocalModel.UI")._METATABLE] = "ItsyScape.Game.Model.UI",
}

EventQueue.CONFIG = {
	metatable = {
		[require("ItsyScape.Common.Math.Ray")._METATABLE] = true,
		[require("ItsyScape.Common.Math.Vector")._METATABLE] = true,
		[require("ItsyScape.Common.Math.Quaternion")._METATABLE] = true,
		[require("ItsyScape.Game.CacheRef")._METATABLE] = true,
		[require("ItsyScape.Game.PlayerStorage")._METATABLE] = true,
		[require("ItsyScape.Game.PlayerStorage").Section._METATABLE] = true,
		[require("ItsyScape.Game.RPC.Event")._METATABLE] = true,
		[require("ItsyScape.Graphics.Color")._METATABLE] = true,
		[require("ItsyScape.Graphics.DecorationMaterial")._METATABLE] = true,
		[require("ItsyScape.World.Map")._METATABLE] = true,
		[require("ItsyScape.World.Tile")._METATABLE] = true,
	},
	proxy = {
		[require("ItsyScape.Game.RemoteModel.Actor")._METATABLE] = true,
		[require("ItsyScape.Game.RemoteModel.Game")._METATABLE] = true,
		[require("ItsyScape.Game.RemoteModel.Player")._METATABLE] = true,
		[require("ItsyScape.Game.RemoteModel.Prop")._METATABLE] = true,
		[require("ItsyScape.Game.RemoteModel.Stage")._METATABLE] = true,
		[require("ItsyScape.Game.RemoteModel.UI")._METATABLE] = true,
		[require("ItsyScape.Game.LocalModel.Actor")._METATABLE] = true,
		[require("ItsyScape.Game.LocalModel.Game")._METATABLE] = true,
		[require("ItsyScape.Game.LocalModel.Player")._METATABLE] = true,
		[require("ItsyScape.Game.LocalModel.Prop")._METATABLE] = true,
		[require("ItsyScape.Game.LocalModel.Stage")._METATABLE] = true,
		[require("ItsyScape.Game.LocalModel.UI")._METATABLE] = true,
	}
}

function EventQueue.newBuffer(gameManager)
	local metatable = EventQueue.METATABLE
	local proxy = EventQueue.PROXY

	local proxyInstances = {}
	for _, typeName in pairs(proxy) do
		local objectInstances = setmetatable({}, {
			__mode = "v",
			__index = function(self, id)
				print(">>> instance", typeName, id)
				local instance = gameManager:getInstance(typeName, id):getInstance()
				if not instance then
					error("not found")
				end

				self[id] = instance
				return instance
			end
		})

		proxyInstances[typeName] = objectInstances
	end

    return NPooledBuffer.new(table.clear), {
    	metatable = metatable,
    	proxy = proxy,
    	proxyInstances = proxyInstances,
    	inputTablePool = {},
    	outputTablePool = {}
    }
end

return EventQueue
