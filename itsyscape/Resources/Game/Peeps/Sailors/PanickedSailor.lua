--------------------------------------------------------------------------------
-- Resources/Peeps/Sailors/PanickedSailor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local Player = require "ItsyScape.Peep.Peeps.Player"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local Sailor = Class(Player)

function Sailor:new(resource, name, ...)
	Player.new(self, resource, name or 'PanickedSailor', ...)
end

local HEADS = {
	"Resources/Game/Skins/PlayerKit1/Head/Light.lua",
	"Resources/Game/Skins/PlayerKit1/Head/Medium.lua",
	"Resources/Game/Skins/PlayerKit1/Head/Dark.lua",
	"Resources/Game/Skins/PlayerKit1/Head/Minifig.lua",
}

local HAIRS = {
	"Resources/Game/Skins/PlayerKit1/Hair/Bald.lua",
	"Resources/Game/Skins/PlayerKit1/Hair/Enby.lua",
	"Resources/Game/Skins/PlayerKit1/Hair/Emo.lua",
	"Resources/Game/Skins/PlayerKit1/Hair/ForwardSpike.lua"
}

local HIT_MESSAGES = {
	"We've been hit!",
	"Aaaaaah!",
	"Nooooooo!",
	"We're all gonna die!"
}

function Sailor:ready(director, game)
	Player.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	actor:setBody(
		CacheRef(
			"ItsyScape.Game.Body",
			"Resources/Game/Bodies/Human.lskel"))

	local head = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		HEADS[math.random(#HEADS)])
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_BASE, head)
	local hair = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		HAIRS[math.random(#HAIRS)])
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_ACCENT, hair)
	local eyes = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Eyes/Eyes.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, math.huge, eyes)
	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shirts/White.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, body)
	local neck = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Neck/SailorsStar.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_NECK, Equipment.SKIN_PRIORITY_BASE, neck)
	local hands = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Hands/SailorBlueGloves.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HANDS, Equipment.SKIN_PRIORITY_BASE, hands)
	local feet = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shoes/Boots3.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_FEET, Equipment.SKIN_PRIORITY_BASE, feet)

	local runAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Run_Crazy_1/Script.lua")
	self:addResource("animation-walk", runAnimation)

	local map = Utility.Peep.getMapScript(self)
	if map then
		map:listen('hit', function(_, p)
			local health = self:getBehavior(CombatStatusBehavior)
			if health and health.currentHitpoints == 0 then
				return
			end

			if p:getDamageType() ~= 'leak' then
				local message = HIT_MESSAGES[math.random(#HIT_MESSAGES)]

				local actor = self:getBehavior(ActorReferenceBehavior)
				if actor and actor.actor then
					actor = actor.actor

					actor:flash('Message', 1, message)
				end
			end
		end)
	end
end

function Sailor:onDie()
	local health = self:getBehavior(CombatStatusBehavior)
	if health then
		local mapScript = Utility.Peep.getMapScript(self)
		if mapScript then
			mapScript:poke('hit', AttackPoke({
				damage = health.maximumHitpoints * 2,
				aggressor = self
			}))
		end
	end
end

return Sailor
