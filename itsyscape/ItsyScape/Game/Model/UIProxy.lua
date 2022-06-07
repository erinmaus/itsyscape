--------------------------------------------------------------------------------
-- ItsyScape/Game/Model/UIProxy.lua
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

local UIProxy = {}

UIProxy.open = Event.ServerToClientRPC(
	Event.Argument("interfaceID"),
	Event.Argument("index"))
UIProxy.open:link("onOpen", Event.Argument("interfaceID"), Event.Argument("index"))
UIProxy.poke = Event.ClientToServerRPC(
	Event.Argument("interfaceID"),
	Event.Argument("index"),
	Event.Argument("actionID"),
	Event.Argument("actionIndex"),
	Event.Argument("e"))
UIProxy.sendPoke = Event.ServerToClientRPC(
	Event.Argument("interfaceID"),
	Event.Argument("index"),
	Event.Argument("actionID"),
	Event.Argument("actionIndex"),
	Event.Argument("e"))
UIProxy.sendPoke:link("onPoke",
	Event.Argument("interfaceID"),
	Event.Argument("index"),
	Event.Argument("actionID"),
	Event.Argument("actionIndex"),
	Event.Argument("e"))

UIProxy.INTERFACE = "interface"
UIProxy.push = Event.Set(
	UIProxy.INTERFACE,
	Event.KeyArgument("interfaceID"),
	Event.KeyArgument("index"),
	Event.Argument("state"))
UIProxy.push:link(
	"onPush",
	Event.Argument("interfaceID"),
	Event.Argument("index"),
	Event.Argument("state"))
UIProxy.pull = Event.Get(
	UIProxy.INTERFACE,
	Event.KeyArgument("interfaceID"),
	Event.KeyArgument("index"),
	Event.Return("e"))
UIProxy.close = Event.Unset(
	UIProxy.INTERFACE,
	Event.KeyArgument("interfaceID"),
	Event.KeyArgument("index"))
UIProxy.close:link(
	"onClose",
	Event.Argument("interfaceID"),
	Event.Argument("index"))

return Proxy(UIProxy)
