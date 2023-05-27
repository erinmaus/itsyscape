--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/HasBuff.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local PowerCoolDownBehavior = require "ItsyScape.Peep.Behaviors.PowerCoolDownBehavior"
local PendingPowerBehavior = require "ItsyScape.Peep.Behaviors.PendingPowerBehavior"

local HasBuff = B.Node("HasBuff")
HasBuff.TARGET = B.Reference()
HasBuff.EFFECT_TYPE = B.Reference()
HasBuff.BUFF_TYPE = B.Reference()

function HasBuff:update(mashina, state, executor)
	local target = state[self.TARGET] or mashina

	local effectType = state[self.EFFECT_TYPE]
	if type(effectType) == 'string' then
		effectType = Utility.Peep.getEffectType(effectType, target:getDirector():getGameDB())
	end

	local buffType = state[self.BUFF_TYPE]
	if buffType then
		for effect in target:getEffects(effectType) do
			if effect:getBuffType() == buffType then
				return B.Status.Success
			end
		end
	else
		if target:getEffect(effectType) ~= nil then
			return B.Status.Success
		end
	end

	return B.Status.Failure
end

return HasBuff
