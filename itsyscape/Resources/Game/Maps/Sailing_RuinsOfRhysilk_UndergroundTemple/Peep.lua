--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_RuinsOfRhysilk_UndergroundTemple/Peep.lua
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
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local Probe = require "ItsyScape.Peep.Probe"
local Map = require "ItsyScape.Peep.Peeps.Map"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local Ruins = Class(Map)
Ruins.MAX_DAMAGE = 1000
Ruins.MIN_DAMAGE = 5000
Ruins.INITIAL_DRAMATIC_WAIT = 5
Ruins.POST_DRAMATIC_WAIT = 1
Ruins.MAX_DAMAGE = 50

function Ruins:new(resource, name, ...)
	Map.new(self, resource, name or 'RuinsOfRhysilk_UndergroundTemple', ...)
end

function Ruins:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Sailing_RuinsOfRhysilk_UndergroundTemple_Fungus', 'Fungal', {
		gravity = { 0, -1, 0 },
		wind = { -1, 0, 0 },
		colors = {
			{ 0.43, 0.54, 0.56, 1.0 },
			{ 0.63, 0.74, 0.76, 1.0 }
		},
		minHeight = 12,
		maxHeight = 20,
		heaviness = 0.25
	})
end

function Ruins:onPlayerEnter(player)
	local peep = player:getActor():getPeep()
	self:initTroll(peep)
	self:hurtPlayer(peep)

	if _DEBUG then
		self:initCutscene(peep)
	end
end

function Ruins:initTroll(player)
	local yendor = self:getDirector():probe(self:getLayerName(), Probe.namedMapObject("Yendor"))[1]

	if yendor then
		local encounteredYendor = player:getState():has("KeyItem", "Sailing_YendorTroll")
		if not encounteredYendor then
			Utility.UI.openInterface(player, "BossHUD", false, yendor)
			self:pushPoke('damageYendor', player, yendor, love.timer.getTime() + Ruins.INITIAL_DRAMATIC_WAIT)
			self:playMusic("SeaAttack2")
		else
			local status = yendor:getBehavior(CombatStatusBehavior)
			status.dead = true
			status.currentHitpoints = 0

			self:playMusic({ "HighChambersYendor1", "HighChambersYendor2" })
		end
	end
end

function Ruins:hurtPlayer(player)
	local status = player:getBehavior(CombatStatusBehavior)
	player:poke('receiveAttack', AttackPoke({
		damage = math.min(math.floor(status.currentHitpoints / 2), Ruins.MAX_DAMAGE)
	}))
end

function Ruins:playMusic(name)
	local stage = self:getDirector():getGameInstance():getStage()
	stage:playMusic(self:getLayer(), "main", name)
end

function Ruins:onDamageYendor(player, yendor, target)
	if love.timer.getTime() > target then
		local damage = math.random(Ruins.MIN_DAMAGE, Ruins.MAX_DAMAGE)
		local attack = AttackPoke({
			damage = damage
		})

		yendor:poke('receiveAttack', attack)

		local status = yendor:getBehavior(CombatStatusBehavior)
		if status.currentHitpoints <= 0 or status.dead then
			player:getState():give("KeyItem", "Sailing_YendorTroll")

			self:playMusic("V2_RuinsOfRhysilk_UndergroundTemple")

			-- Escape early so we don't deal more damage to Yendor.
			return
		end

		self:pushPoke('damageYendor', player, yendor, love.timer.getTime() + Ruins.POST_DRAMATIC_WAIT)
	else
		self:pushPoke('damageYendor', player, yendor, target)
	end
end

function Ruins:initCutscene(player)
	local function actionCallback(action)
		if action == "pressed" then
			self:pushPoke('triggerCutscene', player)
		end
	end

	local function openCallback()
		return not self:wasPoofed()
	end

	Utility.UI.openInterface(
		player,
		"KeyboardAction",
		false,
		"DEBUG_TRIGGER_1", actionCallback, openCallback)
end

function Ruins:onTriggerCutscene(player)
	Utility.UI.closeAll(player)

	local fog1 = self:getDirector():probe(self:getLayerName(), Probe.namedMapObject("Light_Fog1"))[1]
	local fog2 = self:getDirector():probe(self:getLayerName(), Probe.namedMapObject("Light_Fog2"))[1]
	fog1:setNearDistance(60)
	fog1:setFarDistance(90)
	fog2:setNearDistance(90)
	fog2:setFarDistance(120)

	local director = self:getDirector()
	local hits = director:probe(self:getLayerName(), Probe.resource("Peep", "RuinsOfRhysilk_Maggot"))
	for i = 1, #hits do
		Utility.Peep.poof(hits[i])
	end

	local axe = self:getDirector():probe(self:getLayerName(), Probe.namedMapObject("Axe"))[1]
	if axe then
		Utility.Peep.poof(axe)
	end

	local door = self:getDirector():probe(self:getLayerName(), Probe.namedMapObject("Door"))[1]
	if door then
		Utility.Peep.poof(door)
	end

	local archerActor = Utility.spawnMapObjectAtAnchor(self, "Trailer_ArcheryPlayer", "Anchor_ArcheryPlayer_Spawn", 0)
	local meleeActor = Utility.spawnMapObjectAtAnchor(self, "Trailer_MeleePlayer", "Anchor_MeleePlayer_Spawn", 0)

	self:pushPoke('playCutscene', player, {
		Archer = archerActor:getPeep(),
		Warrior = meleeActor:getPeep(),
	})
end

function Ruins:onPlayCutscene(player, entities)
	local cutscene = Utility.Map.playCutscene(self, "Sailing_RuinsOfRhysilk_UndergroundTemple_Trailer", "StandardCutscene", player, entities)
	cutscene:listen('done', self.onFinishCutscene, self, player)
end

function Ruins:onFinishCutscene(player)
	Utility.UI.openGroup(player, Utility.UI.Groups.WORLD)
end

return Ruins
