--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/TargetMoved.lua
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
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local TargetMoved = B.Node("TargetMoved")
TargetMoved.PEEP = B.Reference()
TargetMoved.PREVIOUS_POSITION = B.Local()

function TargetMoved:update(mashina, state, executor)
	local peep = state[self.PEEP]
	if not peep then
		return B.Status.Failure
	end

	local currentI, currentJ, currentK = Utility.Peep.getTile(peep)
	local previousI, previousJ, previousK = unpack(state[self.PREVIOUS_POSITION] or {})

	state[self.PREVIOUS_POSITION] = { currentI, currentJ, currentK }

	if currentI ~= previousI or currentJ ~= previousJ or currentK ~= previousK then
		return B.Status.Success
	else
		return B.Status.Failure
	end
end

return TargetMoved
