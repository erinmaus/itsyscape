--------------------------------------------------------------------------------
-- Resources/Game/Maps/RuinsOfRhysilk/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.Peep.Peeps.Map"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"

local Ruins = Class(Map)

function Ruins:new(resource, name, ...)
	Map.new(self, resource, name or 'RuinsOfRhysilk', ...)
end

function Ruins:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	Utility.spawnMapAtAnchor(self, "Ship_Player1", "Anchor_Ship")
	local beachedShip = Utility.spawnMapAtAnchor(self, "Ship_IsabelleIsland_Pirate", "Anchor_BeachedShip")
	beachedShip:poke('beach')

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Sailing_RuinsOfRhysilk_HeavyRain', 'Rain', {
		wind = { -15, 0, 0 },
		heaviness = 0.5
	})

	local player = Utility.Peep.getPlayer(self)
	local firstMate, pending = SailorsCommon.getActiveFirstMateResource(player)
	if not pending then
		Utility.spawnActorAtAnchor(self, firstMate, "Anchor_FirstMate", 0)
	end
end

return Ruins
