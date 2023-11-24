--------------------------------------------------------------------------------
-- Resources/Game/Effects/BastielsGazeSpeed/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Effect = require "ItsyScape.Peep.Effect"
local MovementEffect = require "ItsyScape.Peep.Effects.MovementEffect"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"

-- Speeds player up by 10% to 20%.
local BastielsGaze = Class(MovementEffect)
BastielsGaze.SKIN = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Effects/BlazingFeet.lua")

BastielsGaze.MIN_LEVEL = 30
BastielsGaze.MAX_LEVEL = 60
BastielsGaze.MIN_BOOST = 0.1
BastielsGaze.MAX_BOOST = 0.2

function BastielsGaze:enchant(peep)
	MovementEffect.enchant(self, peep)

	local actor = peep:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor

		actor:setSkin(
			"x-bastiel-gaze",
			0,
			BastielsGaze.SKIN)
	end
end

function BastielsGaze:sizzle()
	local peep = self:getPeep()

	local actor = peep:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor

		actor:unsetSkin(
			"x-bastiel-gaze",
			0,
			BastielsGaze.SKIN)
	end

	MovementEffect.sizzle(self)
end

function BastielsGaze:getBoost()
	local state = self:getPeep():getState()
	local faithLevel = state:count("Skill", "Faith", { ['skill-as-level'] = true })
	return Utility.Combat.calcBoost(faithLevel, self.MIN_LEVEL or 0, self.MAX_LEVEL or 0, self.MIN_BOOST or 0, self.MAX_BOOST or 0)
end

function BastielsGaze:getBuffType()
	return Effect.BUFF_TYPE_NONE
end

function BastielsGaze:applyToVelocity(velocity)
	return velocity * (1 + self:getBoost())
end

return BastielsGaze
