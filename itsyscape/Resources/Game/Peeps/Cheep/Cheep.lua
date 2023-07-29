--------------------------------------------------------------------------------
-- Resources/Peeps/Cheep/Cheep.lua
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
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"

local Cheep = Class(Creep)
Cheep.ROTATION_MULTIPLIER = math.pi * 2
Cheep.RETURN_TO_IDENTITY_TIME_SECS = 0.5

function Cheep:new(resource, name, ...)
	Creep.new(self, resource, name or 'Cheep_Base', ...)

	self:addBehavior(RotationBehavior)
	self:addBehavior(ScaleBehavior)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1.5, 1.5, 1.5)
	size.offset = Vector.UNIT_Y * -0.75
end

function Cheep:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor
	if actor then
		local body = CacheRef(
			"ItsyScape.Game.Body",
			"Resources/Game/Bodies/Cheep.lskel")
		actor:setBody(body)

		local bodySkin = CacheRef(
			"ItsyScape.Game.Skin.ModelSkin",
			"Resources/Game/Skins/Cheep/Cheep.lua")
		actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, bodySkin)
	end

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Cheep_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Cheep_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	-- local movement = self:getBehavior(MovementBehavior)
	-- movement.maxAcceleration = 4
	-- movement.maxSpeed = 8
	-- movement.float = 0.75

	self.rotation = Quaternion.IDENTITY
	self.targetTime = 0

	Creep.ready(self, director, game)
end

function Cheep:onDie()
	local rotation = self:getBehavior(RotationBehavior)
	rotation.rotation = Quaternion.IDENTITY
end

function Cheep:spin()
	local delta = self:getDirector():getGameInstance():getDelta()

	local targetTile = self:hasBehavior(TargetTileBehavior)
	if targetTile then
		self.isMoving = true
		self.targetTime = self.targetTime + delta
		self.rotation = Quaternion.fromAxisAngle(Vector.UNIT_X, self.targetTime * Cheep.ROTATION_MULTIPLIER)
	else
		if self.isMoving then
			self.isMoving = false
			self.targetTime = 0
			self.previousRotation = self.rotation:getNormal()
		else
			self.previousRotation = self.previousRotation or self.rotation
			self.targetTime = self.targetTime + delta
		end

		local mu = math.min(self.targetTime / Cheep.RETURN_TO_IDENTITY_TIME_SECS, 1)

		self.rotation = self.previousRotation:slerp(Quaternion.fromAxisAngle(Vector.UNIT_X, 0), mu):getNormal()
		self.rotation = Quaternion.IDENTITY
	end
end

function Cheep:update(...)
	Creep.update(self, ...)

	Utility.Peep.face3D(self)
	self:spin()

	local rotation = self:getBehavior(RotationBehavior)
	rotation.rotation = (rotation.rotation * self.rotation):getNormal()

	if not self.isMoving then
		print(">>> rotation", self.rotation:get())
	end
end

return Cheep
