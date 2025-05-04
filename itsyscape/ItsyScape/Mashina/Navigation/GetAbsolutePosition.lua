--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/GetAbsolutePosition.lua
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

local GetAbsolutePosition = B.Node("GetAbsolutePosition")
GetAbsolutePosition.PEEP = B.Reference()
GetAbsolutePosition.RESULT = B.Reference()

function GetAbsolutePosition:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina
	state[self.RESULT] = Utility.Peep.getAbsolutePosition(peep)

	return B.Status.Success
end

return GetAbsolutePosition
