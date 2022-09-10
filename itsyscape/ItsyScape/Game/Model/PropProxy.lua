--------------------------------------------------------------------------------
-- ItsyScape/Game/Model/PropProxy.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Proxy = require "ItsyScape.Game.RPC.Proxy"
local Event = require "ItsyScape.Game.RPC.Event"
local Property = require "ItsyScape.Game.RPC.Property"

local PropProxy = Proxy.Definition()

PropProxy.getID = Property(-1)
PropProxy.getPeepID = Property("null")
PropProxy.getName = Property("Null")
PropProxy.getDescription = Property("This prop hasn't fully loaded yet.")
PropProxy.getResourceName = Property("Null")
PropProxy.getPosition = Property(Vector.ZERO)
PropProxy.getRotation = Property(Quaternion.IDENTITY)
PropProxy.getScale = Property(Vector.ONE)
PropProxy.getTile = Property(0, 0, 0)
PropProxy.getBounds = Property(Vector.ZERO, Vector.ZERO)
PropProxy.getActions = Property.Actions({})
PropProxy.getState = Property({})

return Proxy(PropProxy)
