--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Arachnid/Mite.lua
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
local Equipment = require "ItsyScape.Game.Equipment"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"

local Mite = Class(Creep)
Mite.DEFAULT_SPEED = 6
Mite.DEFAULT_RADIUS = 1.5

function Mite:new(resource, name, ...)
	Creep.new(self, resource, name or 'Mite_Base', ...)

	self:addBehavior(RotationBehavior)
	self:addBehavior(ScaleBehavior)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(3.5, 2.5, 3.5)
end

function Mite:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Mite.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Mite_Walk/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Mite_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Mite_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Mite_Attack/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	Creep.ready(self, director, game)
end

function Mite:runAround()
	local speed
	do
		local movement = self:getBehavior(MovementBehavior)
		if movement then
			speed = movement.maxSpeed
		else
			speed = self.DEFAULT_SPEED
		end
	end

	self.center = self.center or Utility.Peep.getPosition(self)
	self.time = (self.time or (math.random() * speed)) + self:getDirector():getGameInstance():getDelta()

	local map = self:getDirector():getMap(Utility.Peep.getLayer(self))
	if not map then
		return
	end

	local offset
	do
		local tileCenter = map:getTileCenter(map:toTile(self.center.x, self.center.z))
		offset = math.atan2(self.center.z - tileCenter.z, self.center.x - tileCenter.x)
	end

	local delta = self.time

	local x = math.cos(delta * math.pi * 2 + offset)
	local z = math.sin(delta * math.pi * 2 + offset)

	x = x * self.DEFAULT_RADIUS
	z = z * self.DEFAULT_RADIUS

	local position = self.center + Vector(x, 0, z)
	position.y = map:getInterpolatedHeight(position.x, position.z)

	Utility.Peep.lookAt(self, position)
	Utility.Peep.setPosition(self, position)
end

function Mite:update(director, game)
	Creep.update(self, director, game)

	local isInCombat = self:hasBehavior(CombatTargetBehavior)
	local isAlive = Utility.Peep.canAttack(self)
	local isMoving = self:hasBehavior(TargetTileBehavior)
	if not isMoving and not isInCombat and isAlive then
		self:runAround()
	else
		self.time = nil
		self.center = nil

		Utility.Peep.face3D(self)
	end
end

return Mite
