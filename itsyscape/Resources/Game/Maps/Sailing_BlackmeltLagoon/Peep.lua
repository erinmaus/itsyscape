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
local InstancedBehavior = require "ItsyScape.Peep.Behaviors.InstancedBehavior"
local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"

local BlackmeltLagoon = Class(Map)

function BlackmeltLagoon:new(resource, name, ...)
	Map.new(self, resource, name or 'Sailing_BlackmeltLagoon', ...)
end

function BlackmeltLagoon:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Sailing_BlackmeltLagoon_LightRain', 'Rain', {
		wind = { -2, 0, 0 },
		heaviness = 0.125
	})
end

function BlackmeltLagoon:onPlayerEnter(player)
	Utility.spawnMapAtAnchor(self, "Ship_Player1", "Anchor_Ship", {
		isInstancedToPlayer = true,
		player = player
	})

	local firstMate, pending = SailorsCommon.getActiveFirstMateResource(player)
	if not pending then
		local actor = Utility.spawnActorAtAnchor(self, firstMate, "Anchor_FirstMate", 0)
		if actor then
			local _, instancedBehavior = actor:getPeep():addBehavior(InstancedBehavior)
			instancedBehavior.playerID = player:getID()
		end
	end
end

return BlackmeltLagoon
