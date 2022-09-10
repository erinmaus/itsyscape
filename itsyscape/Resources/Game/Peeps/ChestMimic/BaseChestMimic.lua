--------------------------------------------------------------------------------
-- Resources/Peeps/ChestMimic/BaseChestMimic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local WeaponBehavior = require "ItsyScape.Peep.Behaviors.WeaponBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"

local BaseChestMimic = Class(Creep)

function BaseChestMimic:new(resource, name, ...)
	Creep.new(self, resource, name or 'ChestMimic_Base', ...)

	local movement = self:getBehavior(MovementBehavior)
	movement.stoppingForce = 0.5
	movement.maxSpeed = 4
	movement.decay = 0.6
	movement.maxAcceleration = 9
	movement.velocityMultiplier = 1.1
	movement.accelerationMultiplier = 1.1

	self:addBehavior(RotationBehavior)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2, 1, 2)
	size.zoom = 2.5
	size.yPan = Vector(0, 0.5, 0)
end

function BaseChestMimic:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/ChestMimic.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/ChestMimic_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/ChestMimic_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/ChestMimic_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/ChestMimic_Attack/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/ChestMimic/ChestMimic.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)

	Creep.ready(self, director, game)

	Utility.Peep.equipXWeapon(self, "MimicBite")
end

function BaseChestMimic:update(...)
	Creep.update(self, ...)
	Utility.Peep.face3D(self)
end

return BaseChestMimic
