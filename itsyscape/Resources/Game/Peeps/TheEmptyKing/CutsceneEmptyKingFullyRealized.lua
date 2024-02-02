--------------------------------------------------------------------------------
-- Resources/Peeps/TheEmptyKing/CutsceneEmptyKing_FullyRealized.lua
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
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local TheEmptyKing = Class(Creep)
TheEmptyKing.NUM_ATTACK_ANIMATIONS = 3

function TheEmptyKing:new(resource, name, ...)
	Creep.new(self, resource, name or 'TheEmptyKing_FullyRealized', ...)

	local status = self:getBehavior(CombatStatusBehavior)
	status.currentHitpoints = math.huge
	status.maximumHitpoints = math.huge
	status.currentPrayer = math.huge
	status.maximumPrayer = math.huge
	status.maxChaseDistance = math.huge

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2, 6, 2)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxAcceleration = 8
	movement.maxSpeed = 16

	self:addBehavior(RotationBehavior)
end

function TheEmptyKing:ready(director, game)
	Creep.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/TheEmptyKing.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/TheEmptyKing_FullyRealized_Idle_NoWeapon/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/TheEmptyKing_FullyRealized_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	local bonesSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/TheEmptyKing_FullyRealized/Bones.lua")
	actor:setSkin("bones", Equipment.SKIN_PRIORITY_BASE, bonesSkin)

	local handsSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/TheEmptyKing_FullyRealized/Hands.lua")
	actor:setSkin("hands", Equipment.SKIN_PRIORITY_BASE, handsSkin)

	local robesInsideSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/TheEmptyKing_FullyRealized/RobesInside.lua")
	actor:setSkin("robes-inside", Equipment.SKIN_PRIORITY_BASE, robesInsideSkin)

	local robesOutsideSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/TheEmptyKing_FullyRealized/RobesOutside.lua")
	actor:setSkin("robes-outside", Equipment.SKIN_PRIORITY_BASE, robesOutsideSkin)
end

function TheEmptyKing:onSummonZweihander(zweihander)
	local stage = self:getDirector():getGameInstance():getStage()
	stage:fireProjectile("TheEmptyKing_FullyRealized_SummonZweihander", zweihander, self)
end

function TheEmptyKing:onSummonStaff(zweihander)
	local stage = self:getDirector():getGameInstance():getStage()
	stage:fireProjectile("TheEmptyKing_FullyRealized_SummonStaff", zweihander, self)
end

function TheEmptyKing:onInitiateAttack()
	if not self.numAttacks then
		return
	end

	self.numAttacks = self.numAttacks + 1

	if self.numAttacks > self.NUM_ATTACK_ANIMATIONS then
		self.numAttacks = 1
	end

	local isSpecial = self.numAttacks == self.NUM_ATTACK_ANIMATIONS

	local Zweihander = Utility.Peep.getXWeaponType("TheEmptyKing_FullyRealized_Zweihander")
	local Staff = Utility.Peep.getXWeaponType("TheEmptyKing_FullyRealized_Staff")
	local weapon = Utility.Peep.getEquippedWeapon(self, true)

	local attackAnimation
	if Class.isCompatibleType(weapon, Zweihander) then
		if isSpecial then
			attackAnimation = CacheRef(
				"ItsyScape.Graphics.AnimationResource",
				"Resources/Game/Animations/TheEmptyKing_FullyRealized_Attack_Melee_Special/Script.lua")
		else
			attackAnimation = CacheRef(
				"ItsyScape.Graphics.AnimationResource",
				string.format("Resources/Game/Animations/TheEmptyKing_FullyRealized_Attack_Melee%d/Script.lua", self.numAttacks))
		end
	elseif Class.isCompatibleType(weapon, Staff) then
		if isSpecial then
			attackAnimation = CacheRef(
				"ItsyScape.Graphics.AnimationResource",
				"Resources/Game/Animations/TheEmptyKing_FullyRealized_Attack_Magic_Special/Script.lua")
		else
			attackAnimation = CacheRef(
				"ItsyScape.Graphics.AnimationResource",
				string.format("Resources/Game/Animations/TheEmptyKing_FullyRealized_Attack_Magic%d/Script.lua", self.numAttacks))
		end
	end

	if attackAnimation then
		self:addResource("animation-attack", attackAnimation)
	end

	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor

	if actor then
		local idleAnimation = self:getResource(
			"animation-idle",
			"ItsyScape.Graphics.AnimationResource")
		if idleAnimation then
			actor:playAnimation("combat", 100, idleAnimation)
		end
	end
end

function TheEmptyKing:onEquipZweihander(zweihander)
	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor

	if not actor then
		return
	end

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/TheEmptyKing_FullyRealized_Idle_Melee/Script.lua")
	self:addResource("animation-idle", idleAnimation)
	actor:playAnimation("main", 1, idleAnimation)

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/TheEmptyKing_FullyRealized_Attack_Melee1/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	self.numAttacks = 1

	local zweihanderSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/TheEmptyKing_FullyRealized/Zweihander.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_TWO_HANDED, Equipment.SKIN_PRIORITY_BASE, zweihanderSkin)

	Utility.Peep.equipXWeapon(self, "TheEmptyKing_FullyRealized_Zweihander")
end

function TheEmptyKing:onEquipStaff(zweihander)
	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor

	if not actor then
		return
	end

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/TheEmptyKing_FullyRealized_Idle_Magic/Script.lua")
	self:addResource("animation-idle", idleAnimation)
	actor:playAnimation("main", 1, idleAnimation)

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/TheEmptyKing_FullyRealized_Attack_Magic1/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	self.numAttacks = 1

	local zweihanderSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/TheEmptyKing_FullyRealized/Staff.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_TWO_HANDED, Equipment.SKIN_PRIORITY_BASE, zweihanderSkin)

	Utility.Peep.equipXWeapon(self, "TheEmptyKing_FullyRealized_Staff")
end

function TheEmptyKing:update(...)
	Creep.update(self, ...)

	Utility.Peep.face3D(self)
end

return TheEmptyKing
