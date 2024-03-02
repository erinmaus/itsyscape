--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Player/IsNextQuestStep.lua
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
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local IsNextQuestStep = B.Node("IsNextQuestStep")
IsNextQuestStep.PLAYER = B.Reference()
IsNextQuestStep.QUEST = B.Reference()
IsNextQuestStep.STEP = B.Reference()

function IsNextQuestStep:update(mashina, state, executor)
	if Utility.Quest.isNextStep(
		state[self.QUEST],
		state[self.STEP],
		state[self.PLAYER])
	then
		return B.Status.Success
	end

	return B.Status.Failure
end

return IsNextQuestStep
