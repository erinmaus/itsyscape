--------------------------------------------------------------------------------
-- Resources/Peeps/Zombi/ExperimentX.lua
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
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"

local ExperimentX = Class(Creep)

ExperimentX.ANIMATION_NAMES = {
	[Weapon.STYLE_MAGIC] = "Wizard",
	[Weapon.STYLE_ARCHERY] = "Archer",
	[Weapon.STYLE_MELEE] = "Warrior"
}

function ExperimentX:new(resource, name, ...)
	Creep.new(self, resource, name or 'ExperimentX', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(5.5, 6.5, 5.5)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 16

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = math.huge

	self:addBehavior(RotationBehavior)

	self:listen('receiveAttack', Utility.Peep.Attackable.bossReceiveAttack)
	self:addPoke("boss")
end

function ExperimentX:ready(director, game)
	Creep.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor

	if not actor then
		return
	end

	actor:setBody(
		CacheRef(
			"ItsyScape.Game.Body",
			"Resources/Game/Bodies/ExperimentX.lskel"))

	local bodySkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/ExperimentX/ExperimentX.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, bodySkin)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/ExperimentX_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/ExperimentX_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	self:poke("rotateStyle")
end

function ExperimentX:onInitiateAttack()
	self:pushPoke(1, "rotateStyle")
end

function ExperimentX:onRotateStyle()
	local weapon = Utility.Peep.getEquippedWeapon(self, true)
	do
		local style = weapon and Class.isCompatibleType(weapon, Weapon) and weapon:getStyle()

		if style == Weapon.STYLE_MAGIC then
			Utility.Peep.equipXWeapon(self, "ExperimentX_Attack_Melee")
		elseif style == Weapon.STYLE_MELEE then
			Utility.Peep.equipXWeapon(self, "ExperimentX_Attack_Archery")
		else
			Utility.Peep.equipXWeapon(self, "ExperimentX_Attack_Magic")
		end
	end

	weapon = Utility.Peep.getEquippedWeapon(self, true)
	if weapon and Class.isCompatibleType(weapon, Weapon) then
		local style = weapon:getStyle()

		local animationName = ExperimentX.ANIMATION_NAMES[style]
		local idleAnimation = string.format("Resources/Game/Animations/ExperimentX_Idle_%s/Script.lua", animationName)
		local attackAnimation = string.format("Resources/Game/Animations/ExperimentX_Attack_%s/Script.lua", animationName)

		local actor = self:getBehavior(ActorReferenceBehavior)
		actor = actor and actor.actor

		if actor then
			actor:playAnimation(
				"idle",
				10,
				CacheRef("ItsyScape.Graphics.AnimationResource", idleAnimation))
		end

		self:addResource(
			"animation-attack",
			CacheRef("ItsyScape.Graphics.AnimationResource", attackAnimation))
	end
end

function ExperimentX:update(...)
	Creep.update(self, ...)
	Utility.Peep.face3D(self)
end

return ExperimentX
