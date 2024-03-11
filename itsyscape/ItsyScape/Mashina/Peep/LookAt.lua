--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/LookAt.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"

local LookAt = B.Node("LookAt")
LookAt.TARGET = B.Reference()
LookAt.DELTA = B.Reference()

function LookAt:update(mashina, state, executor)
	local target = state[self.TARGET]
	local delta = state[self.DELTA]

	if not target then
		return B.Status.Failure
	end

	Utility.Peep.lookAt(mashina, target, delta)
	return B.Status.Success
end

return LookAt
