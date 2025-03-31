--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/RemoveEffect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"

local RemoveEffect = B.Node("RemoveEffect")
RemoveEffect.TARGET = B.Reference()
RemoveEffect.EFFECT = B.Reference()

function RemoveEffect:update(mashina, state, executor)
	local target = state[self.TARGET] or mashina
	local effect = state[self.EFFECT]

	local success = Utility.Peep.toggleEffect(target,effect, false)
	if success then
		return B.Status.Success
	end

	return B.Status.Failure
end

return RemoveEffect
