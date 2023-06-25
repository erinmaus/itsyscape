--------------------------------------------------------------------------------
-- Resources/Peeps/Rat/BaseRatKing.lua
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
local Equipment = require "ItsyScape.Game.Equipment"
local Probe = require "ItsyScape.Peep.Probe"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local BaseRatKing = Class(Creep)

function BaseRatKing:new(resource, name, ...)
	Creep.new(self, resource, name or 'RatKing_Base', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2, 4, 2)

	local status = self:getBehavior(CombatStatusBehavior)
	status.currentHitpoints = 400
	status.maximumHitpoints = 400
	status.maxChaseDistance = math.huge

	self:addPoke('eat')
	self:addPoke('summon')
end

function BaseRatKing:onSummon()
	Log.info("Trying to summon rats to the Rat King's court...")

	local gameDB = self:getDirector():getGameDB()
	local courtAnchors = gameDB:getRecords("MapObjectGroup", {
		MapObjectGroup = "RatKing_Court",
		Map = Utility.Peep.getMapResource(self)
	})

	for i = 1, #courtAnchors do
		local mapObject = gameDB:getRecord("MapObjectLocation", {
			Map = Utility.Peep.getMapResource(self),
			Resource = courtAnchors[i]:get("MapObject")
		})

		courtAnchors[i] = mapObject
	end

	local court = {}
	for i = 1, #courtAnchors do
		local isAlive = true

		local hits = self:getDirector():probe(self:getLayerName(), Probe.mapObject(courtAnchors[i]:get("Resource")))
		if #hits == 0 then
			isAlive = false
		else
			local status = hits[1]:getBehavior(CombatStatusBehavior)
			if status.dead or status.currentHitpoints == 0 then
				isAlive = false
			end
		end

		court[i] = isAlive
	end

	for i = 1, #court do
		if not court[i] then
			Utility.spawnMapObjectAtAnchor(
				Utility.Peep.getMapScript(self),
				courtAnchors[i]:get("Resource"),
				courtAnchors[i]:get("Name"))

			Log.info("'%s' dead; respawning.", courtAnchors[i]:get("Name"))
		else
			Log.info("'%s' alive; not respawning.", courtAnchors[i]:get("Name"))
		end
	end

	Log.info("Done summoning rats to the court.")
end

function BaseRatKing:onEat(p)
	local target = p.target

	if target then
		local targetStatus = target:getBehavior(CombatStatusBehavior)
		if targetStatus then
			self:poke('heal', {
				hitPoints = math.ceil(targetStatus.maximumHitpoints / 4)
			})
		end
	end
end

function BaseRatKing:onDie(poke)
	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor

	if actor then
		local crown = CacheRef(
			"ItsyScape.Game.Skin.ModelSkin",
			"Resources/Game/Skins/Rat/RatKingCrown.lua")
		actor:unsetSkin(Equipment.PLAYER_SLOT_HEAD, 0, crown)
	end
end

function BaseRatKing:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Rat.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Rat_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Rat_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Rat_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Rat_Attack/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Rat/RatKing.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)
	local crown = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Rat/RatKingCrown.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, 0, crown)

	Utility.Peep.equipXWeapon(self, "RatKing_Bite")

	Creep.ready(self, director, game)
end

return BaseRatKing
