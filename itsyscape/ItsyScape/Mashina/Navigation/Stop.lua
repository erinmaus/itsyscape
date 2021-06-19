--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/Stop.lua
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
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"

local Stop = B.Node("Stop")

function Stop:update(mashina, state, executor)
	mashina:removeBehavior(TargetTileBehavior)

	return B.Status.Success
end

return Stop
