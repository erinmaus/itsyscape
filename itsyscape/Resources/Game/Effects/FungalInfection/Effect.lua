--------------------------------------------------------------------------------
-- Resources/Game/Effects/DreadfulIncenseAccuracyEffect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Effect = require "ItsyScape.Peep.Effect"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Equipment = require "ItsyScape.Game.Equipment"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"

-- Inflicts 1-2 damage/second over 60 seconds.
local FungalInfectionEffect = Class(Effect)
FungalInfectionEffect.DURATION = 60
FungalInfectionEffect.INTERVAL = 1
FungalInfectionEffect.SKIN = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Effects/Mush.lua")

function FungalInfectionEffect:new(aggressor)
	Effect.new(self)

	self.tick = 0
	self.aggressor = aggressor or nil
end

function FungalInfectionEffect:getBuffType()
	return Effect.BUFF_TYPE_NEGATIVE
end

function FungalInfectionEffect:enchant(peep)
	Effect.enchant(self, peep)

	local actor = peep:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor

		actor:setSkin(
			Equipment.PLAYER_SLOT_EFFECT,
			Equipment.SKIN_PRIORITY_BASE,
			FungalInfectionEffect.SKIN)
	end


end

function FungalInfectionEffect:sizzle()
	local peep = self:getPeep()

	local actor = peep:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor

		actor:setSkin(
			Equipment.PLAYER_SLOT_EFFECT,
			false,
			FungalInfectionEffect.SKIN)	
	end

	Effect.sizzle(self)
end

function FungalInfectionEffect:update(delta)
	self.tick = self.tick - delta
	if self.tick < 0 then
		local damage = math.random(1, 2)

		local attack = AttackPoke({
			damage = damage,
			aggressor = self.aggressor
		})

		local peep = self:getPeep()
		if peep then
			peep:poke('receiveAttack', attack)
		end

		self.tick = FungalInfectionEffect.INTERVAL
	end
end

return FungalInfectionEffect
