--------------------------------------------------------------------------------
-- Resources/Peeps/Svalbard/PartiallyDigestedAdventurer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local Peep = require "ItsyScape.Peep.Peep"
local Player = require "ItsyScape.Peep.Peeps.Player"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"

local PartiallyDigestedAdventurer = Class(Player)
PartiallyDigestedAdventurer.SPAWN_COOLDOWN = 5
PartiallyDigestedAdventurer.MAX_DAMAGE_RECEIVABLE = 1
PartiallyDigestedAdventurer.SPAWN_ANIMATION_PRIORITY = 1000
PartiallyDigestedAdventurer.POOF_TIMER = 1

function PartiallyDigestedAdventurer:new(resource, name, ...)
	Player.new(self, resource, name or 'PartiallyDigestedAdventurer', ...)
end

function PartiallyDigestedAdventurer:applyCooldown(duration)
	local _, cooldown = self:addBehavior(AttackCooldownBehavior)

	cooldown.cooldown = duration
	cooldown.ticks = self:getDirector():getGameInstance():getCurrentTick()
end

function PartiallyDigestedAdventurer:onTargetFled()
	self.poofTimer = PartiallyDigestedAdventurer.POOF_TIMER
	self:playPoofAnimation()
end

function PartiallyDigestedAdventurer:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local movement = self:getBehavior(MovementBehavior)
	movement.accelerationMultiplier = 0
	movement.velocityMultiplier = 0

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = 3

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Human.lskel")
	actor:setBody(body)

	local head = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Head/PartiallyDigested.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_BASE, head)
	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shirts/PartiallyDigested.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, body)
	local hands = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Hands/PartiallyDigested.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HANDS, Equipment.SKIN_PRIORITY_BASE, hands)
	local feet = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shoes/Feet_PartiallyDigested.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_FEET, Equipment.SKIN_PRIORITY_BASE, feet)

	Player.ready(self, director, game)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Idle_Painful_1/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	self:clearResources("animation-walk")
	self:clearResources("animation-attack-unarmed")

	self:applyCooldown(PartiallyDigestedAdventurer.SPAWN_COOLDOWN)
	self:playSpawnAnimation()

	Utility.Peep.equipXWeapon(self, "Svalbard_PartiallyDigestedAdventurer_Attack")
end

function PartiallyDigestedAdventurer:playSpawnAnimation()
	local animation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Unearth_1/Script.lua")

	local actor = self:getBehavior(ActorReferenceBehavior).actor
	actor:playAnimation(
		'x-partially-digested-adventurer-spawn',
		PartiallyDigestedAdventurer.SPAWN_ANIMATION_PRIORITY,
		animation)
end

function PartiallyDigestedAdventurer:playPoofAnimation()
	local animation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Unearth_Reversed_1/Script.lua")

	local actor = self:getBehavior(ActorReferenceBehavior).actor
	actor:playAnimation(
		'x-partially-digested-adventurer-spawn',
		PartiallyDigestedAdventurer.SPAWN_ANIMATION_PRIORITY,
		animation)
end

function PartiallyDigestedAdventurer:update(director, game)
	Player.update(self, director, game)

	if self.poofTimer then
		self.poofTimer = self.poofTimer - game:getDelta()
		if self.poofTimer < 0 then
			Utility.Peep.poof(self)
		end
	end
end

return PartiallyDigestedAdventurer
