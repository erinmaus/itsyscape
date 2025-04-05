--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/ApplyEffect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"

local ApplyEffect = B.Node("ApplyEffect")
ApplyEffect.TARGET = B.Reference()
ApplyEffect.EFFECT = B.Reference()
ApplyEffect.SINGULAR = B.Reference()
ApplyEffect.RESULT = B.Reference()

function ApplyEffect:update(mashina, state, executor)
	local target = state[self.TARGET] or mashina
	local effect = state[self.EFFECT]
	local singular = state[self.SINGULAR]

	local success, effect = Utility.Peep.applyEffect(target, effect, singular)
	if success or effect then
		state[self.RESULT] = effect
		return B.Status.Success
	end

	return B.Status.Failure
end

return ApplyEffect
