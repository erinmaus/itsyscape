--------------------------------------------------------------------------------
-- ItsyScape/Mashina/GetLoopResult.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Loop = require "ItsyScape.Mashina.Loop"

local GetLoopResult = B.Node("GetLoopResult")
GetLoopResult.RESULT = B.Reference()

function GetLoopResult:update(mashina, state, executor)
	state[self.RESULT] = state[Loop.RESULT]
	return B.Status.Success
end

return GetLoopResult
