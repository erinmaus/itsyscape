--------------------------------------------------------------------------------
-- ItsyScape/Game/Model/PropProxy.lua
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

local PropProxy = {}

PropProxy.getName = Property()
PropProxy.getDescription = Property()
PropProxy.getResourceName = Property()
PropProxy.getPosition = Property()
PropProxy.getRotation = Property()
PropProxy.getScale = Property()
PropProxy.getTile = Property()
PropProxy.getBounds = Property()
PropProxy.getActions = Property()
PropProxy.getState = Property()

return Proxy(PropProxy)
