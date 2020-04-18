--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_BlackmeltLagoon/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.Peep.Peeps.Map"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"

local BlackmeltLagoon = Class(Map)

function BlackmeltLagoon:new(resource, name, ...)
	Map.new(self, resource, name or 'Sailing_BlackmeltLagoon', ...)
end

function BlackmeltLagoon:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	Utility.spawnMapAtAnchor(self, "Ship_Player1", "Anchor_Ship")

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Sailing_BlackmeltLagoon_LightRain', 'Rain', {
		wind = { -2, 0, 0 },
		heaviness = 0.125
	})

	local player = Utility.Peep.getPlayer(self)
	local firstMate, pending = SailorsCommon.getActiveFirstMateResource(player)
	if not pending then
		Utility.spawnActorAtAnchor(self, firstMate, "Anchor_FirstMate", 0)
	end
end

return BlackmeltLagoon
