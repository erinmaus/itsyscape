--------------------------------------------------------------------------------
-- ItsyScape/Game/Model/GameProxy.lua
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

local GameProxy = {}

GameProxy._quit = Event.ServerToClientRPC()
GameProxy._quit:link("onQuit")
GameProxy.quit = Event.ClientToServerRPC()

GameProxy.getTicks = Property()
GameProxy.getCurrentTick = Property()

return Proxy(GameProxy)