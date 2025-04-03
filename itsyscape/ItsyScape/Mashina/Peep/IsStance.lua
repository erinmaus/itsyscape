--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/IsStance.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local Peep = require "ItsyScape.Peep.Peep"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

local IsStance = B.Node("IsStance")
IsStance.TARGET = B.Reference()
IsStance.STANCE = B.Reference()

function IsStance:update(mashina, state, executor)
	local peep = state[self.TARGET] or mashina
	local desiredStance = state[self.STANCE]

	local _, stance = mashina:addBehavior(StanceBehavior)

	if stance.stance ~= desiredStance then
		return B.Status.Failure
	end

	return B.Status.Success
end

return IsStance
