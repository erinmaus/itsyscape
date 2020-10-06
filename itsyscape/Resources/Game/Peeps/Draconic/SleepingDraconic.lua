--------------------------------------------------------------------------------
-- Resources/Peeps/Draconic/BaseDraconic.lua
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
local BaseDraconic = require "Resources.Game.Peeps.Draconic.BaseDraconic"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local HumanoidActorAnimatorCortex = require "ItsyScape.Peep.Cortexes.HumanoidActorAnimatorCortex"

local SleepingDraconic = Class(BaseDraconic)
SleepingDraconic.SPAWN_BUBBLES_MAX_TICK = 2
SleepingDraconic.POSITION_OFFSET = Vector(1, 1, 1)
SleepingDraconic.MAX_ANIMATION_TIME_OFFSET = 10

function SleepingDraconic:new(resource, name, ...)
	BaseDraconic.new(self, resource, name or 'Draconic', ...)

	self:addBehavior(DisabledBehavior)
end

function SleepingDraconic:ready(director, game)
	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Idle_SleepingInVat/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local actor = self:getBehavior(ActorReferenceBehavior).actor
	actor:playAnimation(
		'main',
		HumanoidActorAnimatorCortex.WALK_PRIORITY,
		idleAnimation,
		true,
		math.random() * SleepingDraconic.MAX_ANIMATION_TIME_OFFSET)

	self:poke('breathe')

	BaseDraconic.ready(self, director, game)
end

function SleepingDraconic:onBreathe()
	local stage = self:getDirector():getGameInstance():getStage()
	local offset = SleepingDraconic.POSITION_OFFSET * Vector(
		math.random() * 2 - 1,
		math.random(),
		math.random() * 2 - 1) + Vector.UNIT_Y

	stage:fireProjectile("HexLab_VatBubbles", self, offset)

	self.nextDuration = math.random() * SleepingDraconic.SPAWN_BUBBLES_MAX_TICK
end

function SleepingDraconic:update(director, game)
	BaseDraconic.update(self, director, game)

	self.nextDuration = self.nextDuration - game:getDelta()
	if self.nextDuration < 0 then
		self:poke('breathe')
	end
end

return SleepingDraconic
