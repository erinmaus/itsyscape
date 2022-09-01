--------------------------------------------------------------------------------
-- ItsyScape/Game/Model/PlayerProxy.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Proxy = require "ItsyScape.Game.RPC.Proxy"
local Event = require "ItsyScape.Game.RPC.Event"
local Property = require "ItsyScape.Game.RPC.Property"

local PlayerProxy = Proxy.Definition()

PlayerProxy.getID = Property()

PlayerProxy.spawn = Event.ClientToServerRPC(Event.Argument("storage"), Event.Argument("newGame"))
PlayerProxy.save = Event.ClientToServerRPC()

PlayerProxy.getActor = Property()
PlayerProxy.isReady = Property()

PlayerProxy.flee = Event.ClientToServerRPC()
PlayerProxy.getIsEngaged = Property()
PlayerProxy.getTarget = Property()

PlayerProxy.move = Event.ClientToServerRPC(Event.Argument("x"), Event.Arguments("z"))
PlayerProxy.walk = Event.ClientToServerRPC(
	Event.Argument("i"), Event.Argument("j"), Event.Arguments("k"))

PlayerProxy.poke = Event.ClientToServerRPC(Event.Argument("id"), Event.Argument("obj"), Event.Argument("scope"))

PlayerProxy.takeItem = Event.ClientToServerRPC(
	Event.Argument("i"),
	Event.Argument("j"),
	Event.Argument("layer"),
	Event.Argument("ref"))

PlayerProxy.pokeCamera = Event.ServerToClientRPC(Event.Argument("event"), Event.Arguments())
PlayerProxy.pokeCamera:link("onPokeCamera", Event.Argument("event"), Event.Arguments())

PlayerProxy.CAMERA = "camera"
PlayerProxy.changeCamera = Event.Set(Event.KeyArgument("cameraType"))
PlayerProxy.changeCamera:link("onChangeCamera", Event.Argument("cameraType"))

return Proxy(PlayerProxy)
