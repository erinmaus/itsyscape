--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/SwapResource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"

local SwapResource = B.Node("SwapResource")
SwapResource.PEEP = B.Reference()
SwapResource.TYPE = B.Reference()
SwapResource.NAME = B.Reference()
SwapResource.PREVIOUS_RESOURCE = B.Reference()

function SwapResource:update(mashina, state, executor)
	local type = state[self.TYPE]
	local name = state[self.NAME]
	if not (type and name) then
		return B.Status.Failure
	end

	local newResource = mashina:getDirector():getGameDB():getResource(name, type)
	if not newResource then
		return B.Status.Failure
	end

	local peep = state[self.PEEP] or mashina

	local previousResource = Utility.Peep.getResource(peep)
	state[self.PREVIOUS_RESOURCE] = previousResource

	Utility.Peep.setResource(peep, newResource)

	return B.Status.Success
end

return SwapResource
