--------------------------------------------------------------------------------
-- Resources/Peeps/Fish/BaseFish.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"

local BaseFish = Class(Creep)

function BaseFish:new(resource, name, ...)
	Creep.new(self, resource, name or 'Fish_Base', ...)

	self:addPoke('swim')
	self:addPoke('stop')
	self:addPoke('roam')

	self.tween = Tween.sineEaseOut
	self.speed = 4
end

function BaseFish:setSpeed(value)
	self.speed = value or self.speed
end

function BaseFish:setTween(func)
	self.tween = func or self.tween
end

function BaseFish:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Fish.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Fish_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Fish_Idle/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	Creep.ready(self, director, game)
end

function BaseFish:onSwim(point, speed, tween)
	self.targetPoint = point
	self.currentPoint = Utility.Peep.getPosition(self)
	self.currentTime = 0
	self.speed = speed or self.speed
	self.tween = Tween[tween or 'linear'] or self.tween
end

function BaseFish:onRoam(minY, maxY)
	self.minY = minY
	self.maxY = maxY
	self.isRoaming = true
end

function BaseFish:onStop()
	self.targetPoint = nil
	self.currentPoint = nil
	self.isRoaming = false
end

function BaseFish:nextTarget()
	local map = Utility.Peep.getMap(self)
	local i = math.random(map:getWidth())
	local j = math.random(map:getHeight())
	local center = map:getTileCenter(i, j)
	local y = math.random() * (self.maxY - self.minY) + self.minY

	self:poke('swim', Vector(center.x, y, center.z), self.speed, self.tween)
end

function BaseFish:update(director, game)
	Creep.update(self, director, game)

	if self.targetPoint and self.currentPoint then
		self.currentTime = self.currentTime + game:getDelta()

		local duration = (self.targetPoint - self.currentPoint):getLength() / self.speed
		local delta = self.tween(math.min(self.currentTime / duration, 1))

		local map = Utility.Peep.getMap(self)
		local newPosition = self.currentPoint:lerp(self.targetPoint, delta)

		local elevation = map:getInterpolatedHeight(newPosition.x, newPosition.z)
		newPosition.y = math.max(elevation, newPosition.y)

		Utility.Peep.setPosition(self, newPosition)

		local movement = self:getBehavior(MovementBehavior)
		if self.targetPoint.x < self.currentPoint.x then
			movement.facing = MovementBehavior.FACING_LEFT
		else
			movement.facing = MovementBehavior.FACING_RIGHT
		end

		if delta >= 1 then
			if self.isRoaming then
				self:nextTarget()
			else
				self:poke('stop')
			end
		end
	elseif self.isRoaming then
		self:nextTarget()
	end
end

return BaseFish
