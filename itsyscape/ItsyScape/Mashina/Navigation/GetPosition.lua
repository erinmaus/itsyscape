--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/GetPosition.lua
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

local GetPosition = B.Node("GetPosition")
GetPosition.PEEP = B.Reference()
GetPosition.RESULT = B.Reference()

function GetPosition:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina
	state[self.RESULT] = Utility.Peep.getPosition(peep)

	return B.Status.Success
end

return GetPosition
