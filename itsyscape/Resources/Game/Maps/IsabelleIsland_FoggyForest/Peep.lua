--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_FoggyForest/Peep.lua
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
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"

local FoggyForest = Class(Map)
FoggyForest.PEEPS = {
	"Zombi_Base_Attackable",
	"Nymph_Base_Attackable_Wand"
}

FoggyForest.ANCHORS = {
	"Anchor_SpawnNorthWest",
	"Anchor_SpawnSouthEast",
	"Anchor_SpawnClearing"
}

function FoggyForest:new(name, ...)
	Map.new(self, name or 'FoggyForest', ...)

	self:addPoke('ancientDriftwoodTreeHit')
	self:addPoke('ancientDriftwoodTreeFelled')
end

function FoggyForest:onAncientDriftwoodTreeHit(e)
	Log.info('Ancient driftwood tree hit; at %d ticks.', e.ticks)

	for i = 1, 3 do
		local peep
		do
			local index = math.random(1, #FoggyForest.PEEPS)
			peep = FoggyForest.PEEPS[index]
		end

		local anchor
		do
			local index = math.random(1, #FoggyForest.ANCHORS)
			anchor = FoggyForest.ANCHORS[index]
		end

		local actor = Utility.spawnActorAtAnchor(self, peep, anchor)
		if actor then
			Log.info("Spawned %s.", actor:getName())
			actor:getPeep():listen('finalize', Utility.Peep.attack, actor:getPeep(), e.peep, math.huge)
		else
			Log.warn("Failed to spawn '%s' @ '%s'.", peep, anchor)
		end
	end
end

function FoggyForest:onAncientDriftwoodTreeFelled(e)
	Log.info('Ancient driftwood tree felled after %d ticks.', e.ticks)
end

return FoggyForest
