--------------------------------------------------------------------------------
-- ItsyScape/Game/Model/GameProxy.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local PlayerProxy = require "ItsyScape.Game.Model.PlayerProxy"
local Proxy = require "ItsyScape.Game.RPC.Proxy"
local Event = require "ItsyScape.Game.RPC.Event"
local Property = require "ItsyScape.Game.RPC.Property"

local GameProxy = Proxy.Definition()

GameProxy._quit = Event.ServerToClientRPC()
GameProxy._quit:link("onQuit")
GameProxy.quit = Event.ClientToServerRPC()

GameProxy.onLeave = Event.ServerToClientRPC()
GameProxy.onLeave:link("onLeave")

GameProxy.getTicks = Property()
GameProxy.getCurrentTick = Property()

GameProxy.spawnPlayer = Event.Create(PlayerProxy, function(event, gameManager, game, player)
	local instance = gameManager:newInstance("ItsyScape.Game.Model.Player", player:getID(), player)
	PlayerProxy:wrapServer("ItsyScape.Game.Model.Player", player:getID(), player, gameManager)
	instance:update()
	gameManager:invokeCallback("ItsyScape.Game.Model.Game", 0, event, game, player)
end, Event.Argument("player", true))
GameProxy.spawnPlayer:link("onPlayerSpawned")

GameProxy.poofPlayer = Event.Destroy(PlayerProxy, function(event, gameManager, game, player)
	gameManager:invokeCallback("ItsyScape.Game.Model.Game", 0, event, game, player)
	gameManager:destroyInstance("ItsyScape.Game.Model.Player", player:getID())
end, Event.Argument("player", true))
GameProxy.poofPlayer:link("onPlayerPoofed")

return Proxy(GameProxy)
