--------------------------------------------------------------------------------
-- Resources/Peeps/ChestMimic/TVMimic.lua
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
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local TVMimic = Class(Creep)

function TVMimic:new(resource, name, ...)
	Creep.new(self, resource, name or 'TVMimic', ...)

	local movement = self:getBehavior(MovementBehavior)
	movement.stoppingForce = 0.5
	movement.maxSpeed = 5
	movement.decay = 0.6
	movement.maxAcceleration = 18
	movement.velocityMultiplier = 1.1
	movement.accelerationMultiplier = 1.1

	self:addBehavior(RotationBehavior)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2, 1, 2)
	size.zoom = 2.5
	size.yPan = Vector(0, 0.5, 0)
end

function TVMimic:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/TVMimic.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/TVMimic_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/TVMimic_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	Utility.spawnPropAtPosition(
		self,
		"TV_Mimic",
		Utility.Peep.getPosition(self):get())

	Creep.ready(self, director, game)
end

function TVMimic:update(...)
	Creep.update(self, ...)
	Utility.Peep.face3D(self)
end

return TVMimic
