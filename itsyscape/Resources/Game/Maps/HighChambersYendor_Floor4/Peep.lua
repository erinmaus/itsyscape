--------------------------------------------------------------------------------
-- Resources/Game/Maps/HighChambersYendor_Floor3/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local BossStat = require "ItsyScape.Game.BossStat"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.Peep.Peeps.Map"
local Probe = require "ItsyScape.Peep.Probe"
local BossStatsBehavior = require "ItsyScape.Peep.Behaviors.BossStatsBehavior"
local HighChambersYendorCommon = require "Resources.Game.Peeps.HighChambersYendor.Common"

local HighChambersYendor = Class(Map)

function HighChambersYendor:new(resource, name, ...)
	Map.new(self, resource, name or 'HighChambersYendor_Floor4', ...)

	self:addBehavior(BossStatsBehavior)
end

function HighChambersYendor:onFinalize(director, game)
	self:initBoss(director, game)
end

function HighChambersYendor:initBoss(director, game)
	self.immunities = {}
	self:initImmunity("Wizard", "MagicImmunity", "Immunity from Magic")
	self:initImmunity("Archer", "ArcheryImmunity", "Immunity from Archery")
	self:initImmunity("Warrior", "MeleeImmunity", "Immunity from Melee")
end

function HighChambersYendor:initImmunity(minion, effect, niceName)
	local director = self:getDirector()
	local gameDB = director:getGameDB()
	do
		local hits = director:probe(
			self:getLayerName(),
			Probe.namedMapObject(minion))
		if #hits >= 1 then
			local minion = hits[1]
			minion:listen('die', self.onMinionKilled, self, effect)
			minion:listen('resurrect', self.onMinionRezzed, self, effect)
		end
	end

	do
		local hits = director:probe(
			self:getLayerName(),
			Probe.namedMapObject("Isabelle"))
		if #hits >= 1 then
			local isabelle = hits[1]

			local effectResource = gameDB:getResource(effect, "Effect")
			Utility.Peep.applyEffect(isabelle, effectResource, true)
		end
	end

	self.immunities[effect] = BossStat({
		icon = string.format('Resources/Game/Effects/%s/Icon.png', effect),
		inColor = { 0.0, 0.0, 0.0, 1.0 },
		outColor = { 1.0, 1.0, 1.0, 1.0 },
		text = niceName,
		current = 1,
		max = 1,
		isBoolean = true
	})

	local stats = self:getBehavior(BossStatsBehavior)
	table.insert(stats.stats, self.immunities[effect])
end

function HighChambersYendor:onMinionKilled(effect)
	local director = self:getDirector()
	local gameDB = director:getGameDB()
	local hits = director:probe(
		self:getLayerName(),
		Probe.namedMapObject("Isabelle"))
	if #hits >= 1 then
		local isabelle = hits[1]

		local effectResource = gameDB:getResource(effect, "Effect")
		local EffectType = Utility.Peep.getEffectType(effectResource, gameDB)
		for effect in isabelle:getEffects(EffectType) do
			isabelle:removeEffect(effect)
			break
		end
	end

	self.immunities[effect]:set({
		current = 0
	})
end

function HighChambersYendor:onMinionRezzed(effect)
	local director = self:getDirector()
	local gameDB = director:getGameDB()
	local hits = director:probe(
		self:getLayerName(),
		Probe.namedMapObject("Isabelle"))
	if #hits >= 1 then
		local isabelle = hits[1]

		local effectResource = gameDB:getResource(effect, "Effect")
		Utility.Peep.applyEffect(isabelle, effectResource, true)
	end

	self.immunities[effect]:set({
		current = 1
	})
end

return HighChambersYendor
