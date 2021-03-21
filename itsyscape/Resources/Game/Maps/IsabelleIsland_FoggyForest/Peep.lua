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
local Vector = require "ItsyScape.Common.Math.Vector"
local BossStat = require "ItsyScape.Game.BossStat"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.Peep.Peeps.Map"
local BossStatsBehavior = require "ItsyScape.Peep.Behaviors.BossStatsBehavior"
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

FoggyForest.NUM_FOES = 3
FoggyForest.NUM_TICKS = 5

FoggyForest.BOSS_UNATTACKABLE = "IsabelleIsland_FoggyForest_BossyNymph_Unattackable"
FoggyForest.BOSS_ATTACKABLE = "IsabelleIsland_FoggyForest_BossyNymph"
FoggyForest.BOSS_ANCHOR = "Anchor_SpawnClearing"
FoggyForest.BOSS_MESSAGES = {
	"Kill this fool, minions!",
	"I summon death!",
	"The Ancient driftwood will not be felled!",
	"Stop it! Kill this pitiful adventurer, minions!"
}

function FoggyForest:new(resource, name, ...)
	Map.new(self, resource, name or 'FoggyForest', ...)

	self:addPoke('ancientDriftwoodTreeHit')
	self:addPoke('ancientDriftwoodTreeFelled')

	self.nymph = false

	self:addBehavior(BossStatsBehavior)

	self.numFoesStat = BossStat({
		icon = "Resources/Game/UI/Icons/Concepts/Rage.png",
		text = "Foes remaining",
		inColor = { 0.78, 0.21, 0.21, 1.0 },
		outColor = { 0.21, 0.67, 0.78, 1.0 },
		current = 0,
		max = 0
	})

	self.treeHealthStat = BossStat({
		icon = "Resources/Game/Items/CopperHatchet/Icon.png",
		text = "Tree health",
		inColor = { 0.78, 0.21, 0.21, 1.0 },
		outColor = { 0.21, 0.67, 0.78, 1.0 },
		current = FoggyForest.NUM_TICKS,
		max = FoggyForest.NUM_TICKS
	})

	local stats = self:getBehavior(BossStatsBehavior)
	table.insert(stats.stats, self.numFoesStat)
	table.insert(stats.stats, self.treeHealthStat)
end

function FoggyForest:spawnBossyNymph()
	local player = Utility.Peep.getPlayer(self)
	local adjacent = Utility.Peep.getPosition(player) - Vector.UNIT_X * 2
	local actor = Utility.spawnActorAtPosition(self, FoggyForest.BOSS_UNATTACKABLE, adjacent.x, adjacent.y, adjacent.z, 0)

	self.nymph = actor:getPeep()

	self.nymph:listen('finalize', function()
		Utility.UI.openInterface(player, "BossHUD", false, self.nymph)

		local actions = Utility.getActions(
			self:getDirector():getGameInstance(),
			Utility.Peep.getResource(self.nymph),
			'world')
		for i = 1, #actions do
			if actions[i].instance:is("talk") then
				return Utility.UI.openInterface(
					player,
					"DialogBox",
					true,
					actions[i].instance:getAction(),
					self.nymph)
			end
		end
	end)

	self.nymph:listen('die', function()
		player:getState():give("KeyItem", "CalmBeforeTheStorm_KilledBoundNymph", 1)
	end)
end

function FoggyForest:spawnFoes(e)
	for i = 1, FoggyForest.NUM_FOES do
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
			actor:getPeep():listen('die', function()
				self.numFoesStat.currentValue = self.numFoesStat.currentValue - 1
			end)
		else
			Log.warn("Failed to spawn '%s' @ '%s'.", peep, anchor)
		end
	end

	self:makeNymphTalk(FoggyForest.BOSS_MESSAGES[math.random(#FoggyForest.BOSS_MESSAGES)])

	self.numFoesStat.currentValue = self.numFoesStat.currentValue + FoggyForest.NUM_FOES
	self.numFoesStat.maxValue = self.numFoesStat.currentValue + FoggyForest.NUM_FOES
end

function FoggyForest:makeNymphTalk(message)
	if self.nymph then
		local actor = self.nymph:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			actor = actor.actor
			actor:flash('Message', 1, message, nil, 2.5)
		end
	end
end

function FoggyForest:onAncientDriftwoodTreeHit(e)
	Log.info('Ancient driftwood tree hit; at %d ticks.', e.ticks)

	if not self.nymph then
		Log.info("Spawning bossy nymph...")
		self:spawnBossyNymph()
	else
		self:spawnFoes(e)
	end

	self.treeHealthStat.currentValue = self.treeHealthStat.currentValue - 1
end

function FoggyForest:onAncientDriftwoodTreeFelled(e)
	Log.info('Ancient driftwood tree felled after %d ticks.', e.ticks)

	local gameDB = self:getDirector():getGameDB()
	Utility.Peep.setResource(self.nymph, gameDB:getResource(FoggyForest.BOSS_ATTACKABLE, "Peep"))
	Utility.Peep.attack(self.nymph, e.peep or Utility.Peep.getPlayer(self))

	self:makeNymphTalk("Nooooo! FEEL MY WRATH!")

	self.treeHealthStat.currentValue = self.treeHealthStat.currentValue - 1
end

return FoggyForest
