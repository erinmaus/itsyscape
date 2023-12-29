--------------------------------------------------------------------------------
-- Resources/Peeps/Zombi/FleshyPillar.lua
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
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"

local FleshyPillar = Class(Creep)

function FleshyPillar:new(resource, name, ...)
	Creep.new(self, resource, name or 'FleshyPillar', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2.5, 4.5, 2.5)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 0
	movement.maxAcceleration = 0

	local _, rotation = self:addBehavior(RotationBehavior)
	rotation.rotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, love.math.random() * math.pi * 2)

	self:silence("receiveAttack", Utility.Peep.Attackable.aggressiveOnReceiveAttack)
	self:listen("receiveAttack", Utility.Peep.Attackable.onReceiveAttack)
end

function FleshyPillar:ready(director, game)
	Creep.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor

	if not actor then
		return
	end

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = 0
	status.currentHitpoints = 300
	status.maximumHitpoints = 300

	actor:setBody(
		CacheRef(
			"ItsyScape.Game.Body",
			"Resources/Game/Bodies/FleshyPillar.lskel"))

	local bodySkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/FleshyPillar/FleshyPillar.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, bodySkin)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/FleshyPillar_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/FleshyPillar_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	local defendAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/FleshyPillar_Defend/Script.lua")
	self:addResource("animation-defend", defendAnimation)
end

return FleshyPillar
