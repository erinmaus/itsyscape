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
local Vector = require "ItsyScape.Common.Math.Vector"
local BossStat = require "ItsyScape.Game.BossStat"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.Peep.Peeps.Map"
local Probe = require "ItsyScape.Peep.Probe"
local BossStatsBehavior = require "ItsyScape.Peep.Behaviors.BossStatsBehavior"
local HighChambersYendorCommon = require "Resources.Game.Peeps.HighChambersYendor.Common"

local HighChambersYendor = Class(Map)
HighChambersYendor.WATER_FLOOD = {
	texture = "LightFoamyWater1",
	i = 1,
	j = 16,
	width = 24,
	height = 5,
	y = 0.5
}

HighChambersYendor.WATER_DRAIN = {
	texture = "LightFoamyWater1",
	i = 1,
	j = 16,
	width = 24,
	height = 5,
	y = -0.5
}

function HighChambersYendor:new(resource, name, ...)
	Map.new(self, resource, name or 'HighChambersYendor_Floor4', ...)

	self:addBehavior(BossStatsBehavior)
end

function HighChambersYendor:onFinalize(director, game)
	self:initBoss(director, game)
	self:initWater(director, game)
end

function HighChambersYendor:initBoss(director, game)
	self.immunities = {}
	self:initImmunity("Wizard", "MagicImmunity", "Immunity from Magic")
	self:initImmunity("Archer", "ArcheryImmunity", "Immunity from Archery")
	self:initImmunity("Warrior", "MeleeImmunity", "Immunity from Melee")

	do
		local hits = director:probe(
			self:getLayerName(),
			Probe.namedMapObject("Isabelle"))
		if #hits >= 1 then
			isabelle = hits[1]

			local mapObject = Utility.Map.getMapObject(
				game,
				"HighChambersYendor_Floor4",
				"Isabelle_Dummy")
			Utility.Peep.setMapObject(isabelle, mapObject)
		end
	end
end

function HighChambersYendor:initImmunity(minion, effect, niceName)
	self.immunities[effect] = BossStat({
		icon = string.format('Resources/Game/Effects/%s/Icon.png', effect),
		inColor = { 0.0, 0.0, 0.0, 1.0 },
		outColor = { 1.0, 1.0, 1.0, 1.0 },
		text = niceName,
		current = 1,
		max = 1,
		isBoolean = true
	})

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

			minion:poke('die')
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

function HighChambersYendor:initWater(director, game)
	local stage = game:getStage()
	local player = game:getPlayer():getActor():getPeep()
	local state = player:getState()

	if state:has("KeyItem", "HighChambersYendor_Lever1") and
	   state:has("KeyItem", "HighChambersYendor_Lever2") and
	   state:has("KeyItem", "HighChambersYendor_Lever3")
	then
		stage:flood("HighChambersYendor_Floor4_Canal", HighChambersYendor.WATER_DRAIN, self:getLayer())
	else
		stage:flood("HighChambersYendor_Floor4_Canal", HighChambersYendor.WATER_FLOOD, self:getLayer())

		local anchorTopLeft = Vector(Utility.Map.getAnchorPosition(game, "HighChambersYendor_Floor4", "Anchor_Bridge_TopLeft"))
		local anchorBottomRight = Vector(Utility.Map.getAnchorPosition(game, "HighChambersYendor_Floor4", "Anchor_Bridge_BottomRight"))
		local map = stage:getMap(self:getLayer())

		local t, l, r, b
		do
			local _, i, j = map:getTileAt(anchorTopLeft.x, anchorTopLeft.z)
			l = i
			t = j
		end
		do
			local _, i, j = map:getTileAt(anchorBottomRight.x, anchorBottomRight.z)
			r = i
			b = j
		end

		for j = t, b do
			for i = l, r do
				local tile = map:getTile(i, j)
				tile:pushFlag('impassable')
			end
		end
	end
end

return HighChambersYendor
