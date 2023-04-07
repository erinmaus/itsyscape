--------------------------------------------------------------------------------
-- ItsyScape/Peep/Effects/PrayerCombatEffect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"

local PrayerCombatEffect = Class(CombatEffect)

function PrayerCombatEffect:enchant(peep)
	CombatEffect.enchant(self, peep)

	local gameDB = peep:getDirector():getGameDB()
	local prayer = gameDB:getRecord("Prayer", {
		Resource = self:getResource()
	})

	if prayer then
		self.drain = prayer:get("Drain")
	end

	self:playAnimation()
end

function PrayerCombatEffect:playAnimation()
	local peep = self:getPeep()

	local prayAnimation = peep:getResource("animation-action-pray", "ItsyRealm.Graphics.AnimationResource")
	if prayAnimation then
		local actor = peep:getBehavior(ActorReferenceBehavior)
		actor = actor and actor.actor

		if actor then
			actor:playAnimation("skill", 5, prayAnimation)
		end
	end
end

function PrayerCombatEffect:getBoost()
	local state = self:getPeep():getState()
	local faithLevel = state:count("Skill", "Faith", { ['skill-as-level'] = true })
	return Utility.Combat.calcBoost(faithLevel, self.MIN_LEVEL or 0, self.MAX_LEVEL or 0, self.MIN_BOOST or 0, self.MAX_BOOST or 0)
end

function PrayerCombatEffect:getDrain()
	return self.drain or 0
end

function PrayerCombatEffect:update(delta)
	CombatEffect.update(self, delta)

	local peep = self:getPeep()
	if peep then
		local status = peep:getBehavior(CombatStatusBehavior)
		if not status or status.currentPrayer <= 0 then
			peep:removeEffect(self)
		end
	end
end

return PrayerCombatEffect
