--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/IsHuman.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"

local IsHuman = B.Node("IsHuman")
IsHuman.PEEP = B.Reference()

function IsHuman:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina

	if peep:hasBehavior(HumanoidBehavior) then
		return B.Status.Success
	end

	return B.Status.Failure
end

return IsHuman
