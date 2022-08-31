--------------------------------------------------------------------------------
-- Resources/Game/Maps/Trailer_Sailing/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local Map = require "ItsyScape.Peep.Peeps.Map"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"

local Trailer = Class(Map)

function Trailer:new(resource, name, ...)
	Map.new(self, resource, name or 'Trailer_Sailing', ...)
end

function Trailer:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local beachedShip = Utility.spawnMapAtAnchor(self, "Ship_IsabelleIsland_Pirate", "Anchor_BeachedShip")
	beachedShip:poke('beach')
end

return Trailer
