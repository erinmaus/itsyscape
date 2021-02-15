--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/IsDead.lua
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
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local IsDead = B.Node("IsDead")
IsDead.PEEP = B.Reference()

function IsDead:update(mashina, state, executor)
	local peep = state[self.PEEP]
	if not peep then
		return B.Status.Success
	end

	local status = peep:getBehavior(CombatStatusBehavior)
	if not status then
		return B.Status.Failure
	end

	if status.dead or status.currentHitpoints == 0 then
		return B.Status.Success
	else
		return B.Status.Failure
	end
end

return IsDead
