--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/HasZeal.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local HasZeal = B.Node("HasZeal")
HasZeal.TARGET = B.Reference()
HasZeal.ZEAL = B.Reference()

function HasZeal:update(mashina, state, executor)
	local gameDB = mashina:getDirector():getGameDB()

	local peep = state[self.TARGET] or mashina
 	local zeal = math.floor((state[self.ZEAL] or 0) * 100)

	local status = peep:getBehavior(CombatStatusBehavior)
	local currentZeal = status and math.floor(status.currentZeal * 100) or 0

	if zeal > currentZeal then
		return B.Status.Failure
	end

	return B.Status.Success
end

return HasZeal
