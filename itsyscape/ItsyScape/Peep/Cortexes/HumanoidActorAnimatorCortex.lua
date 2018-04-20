--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/HumanoidActorAnimatorCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local Cortex = require "ItsyScape.Peep.Cortex"
local CacheRef = require "ItsyScape.Game.CacheRef"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"

local HumanoidActorAnimatorCortex = Class(Cortex)
HumanoidActorAnimatorCortex.WALK_ANIMATION = CacheRef(
	"ItsyScape.Graphics.AnimationResource",
	"Resources/Game/Animations/Human_Walk_1/Script.lua"
)
HumanoidActorAnimatorCortex.IDLE_ANIMATION = CacheRef(
	"ItsyScape.Graphics.AnimationResource",
	"Resources/Game/Animations/Human_Idle_1/Script.lua"
)

function HumanoidActorAnimatorCortex:new()
	Cortex.new(self)

	self:require(ActorReferenceBehavior)
	self:require(HumanoidBehavior)
	self:require(MovementBehavior)

	self.walking = {}
	self.idling = {}
end

function HumanoidActorAnimatorCortex:update(delta)
	local game = self:getDirector():getGameInstance()
	local finished = {}

	for peep in self:iterate() do
		local velocity = peep:getBehavior(MovementBehavior).velocity
		local actor = peep:getBehavior(ActorReferenceBehavior).actor

		-- TODO this needs to be better
		if velocity:getLength() > 0.1 then
			if not self.walking[actor] then
				actor:playAnimation('main', 1, HumanoidActorAnimatorCortex.WALK_ANIMATION)
				self.walking[actor] = true
				self.idling[actor] = nil
			end
		else
			if not self.idling[actor] then
				actor:playAnimation('main', 1, HumanoidActorAnimatorCortex.IDLE_ANIMATION)
				self.idling[actor] = true
				self.walking[actor] = false
			end
		end
	end
end

return HumanoidActorAnimatorCortex
