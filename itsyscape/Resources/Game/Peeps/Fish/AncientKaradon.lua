--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Fish/AncientKaradon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local AncientKaradon = Class(Creep)

AncientKaradon.STATE_DIVE   = 'dive'
AncientKaradon.STATE_SWIM   = 'swim'
AncientKaradon.STATE_RISE   = 'rise'
AncientKaradon.STATE_TARGET = 'target'

AncientKaradon.SWIM_RADIUS = 1
AncientKaradon.SWIM_SPEED  = math.pi / 2

AncientKaradon.DIVE_OFFSET_Y         = 5
AncientKaradon.DIVE_DURATION_SECONDS = 1.5

function AncientKaradon:new(resource, name, ...)
	Creep.new(self, resource, name or 'AncientKaradon', ...)

	self:addPoke('dive')
	self:addPoke('swim')
	self:addPoke('rise')
	self:addPoke('target')
end

function AncientKaradon:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(6.5, 8.5, 6.5)
	size.offset = Vector.UNIT_Y * 4

	local status = self:getBehavior(CombatStatusBehavior)
	status.currentHitpoints = 400
	status.maximumHitpoints = 400
	status.maxChaseDistance = math.huge

	local movement = self:getBehavior(MovementBehavior)
	movement.noClip = true

	self:addBehavior(RotationBehavior)

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/AncientKaradon.lskel")
	actor:setBody(body)

	local skin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Fish/AncientKaradon.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, skin)

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/AncientKaradon_Attack_Magic/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/AncientKaradon_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/AncientKaradon_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	self:poke('dive')

	Utility.Peep.equipXWeapon(self, "AncientKaradon_Magic")

	Creep.ready(self, director, game)
end

function AncientKaradon:onDive()
	self.currentAnimationState = AncientKaradon.STATE_DIVE
	self.currentDiveTime = 0
	self.startDiveY = Utility.Peep.getPosition(self).y
	self.targetDiveY = self.startDiveY - AncientKaradon.DIVE_OFFSET_Y
end

function AncientKaradon:onSwim()
	local position = Utility.Peep.getPosition(self)
	local angle = love.math.random() * math.pi * 2
	local x = position.x - math.cos(angle) * AncientKaradon.SWIM_RADIUS
	local z = position.z - math.sin(angle) * AncientKaradon.SWIM_RADIUS

	self.currentAnimationState = AncientKaradon.STATE_SWIM
	self.swimCenter = Vector(x, position.y, z)
	self.currentAngle = angle
end

function AncientKaradon:onRise(target)
	self.target = target

	self.currentAnimationState = AncientKaradon.STATE_RISE
	self.currentDiveTime = 0
	self.startDiveY = Utility.Peep.getPosition(self).y
	self.targetDiveY = self.startDiveY + AncientKaradon.DIVE_OFFSET_Y
end

function AncientKaradon:onTarget()
	self.currentAnimationState = AncientKaradon.STATE_TARGET

	self.target = nil
end

function AncientKaradon:update(...)
	Creep.update(self, ...)

	local delta = self:getDirector():getGameInstance():getDelta()

	if self.currentAnimationState == AncientKaradon.STATE_DIVE or self.currentAnimationState == AncientKaradon.STATE_RISE then
		self.currentDiveTime = self.currentDiveTime + delta

		local currentPosition = Utility.Peep.getPosition(self)
		local startPosition = Vector(currentPosition.x, self.startDiveY, currentPosition.z)
		local endPosition = Vector(currentPosition.x, self.targetDiveY, currentPosition.z)

		local mu = Tween.sineEaseOut(math.min(self.currentDiveTime / AncientKaradon.DIVE_DURATION_SECONDS, 1))
		local currentPosition = startPosition:lerp(endPosition, mu)

		Utility.Peep.setPosition(self, currentPosition)

		if self.currentDiveTime > AncientKaradon.DIVE_DURATION_SECONDS then
			if self.currentAnimationState == AncientKaradon.STATE_DIVE then
				self:poke('swim')
			else
				self:poke('target')
			end
		end

		if self.currentAnimationState == AncientKaradon.STATE_RISE then
			Utility.Peep.lookAt(self, self.target)
		end
	elseif self.currentAnimationState == AncientKaradon.STATE_SWIM then
		self.currentAngle = self.currentAngle + AncientKaradon.SWIM_SPEED * delta

		local x = math.cos(self.currentAngle) * AncientKaradon.SWIM_RADIUS
		local z = math.sin(self.currentAngle) * AncientKaradon.SWIM_RADIUS

		local currentPosition = Utility.Peep.getPosition(self)
		local nextPosition = Vector(x, 0, z) + self.swimCenter

		Utility.Peep.lookAt(self, nextPosition)
		Utility.Peep.setPosition(self, nextPosition)
	elseif self.currentAnimationState == AncientKaradon.STATE_TARGET then
		Utility.Peep.face3D(self)
	end

	if self.currentAnimationState ~= AncientKaradon.STATE_TARGET then
		self:removeBehavior(CombatTargetBehavior)
	end
end

return AncientKaradon
