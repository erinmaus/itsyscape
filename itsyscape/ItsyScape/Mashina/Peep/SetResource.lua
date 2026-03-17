--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/SetResource.lua
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

local SetResource = B.Node("SetResource")
SetResource.PEEP = B.Reference()
SetResource.TYPE = B.Reference()
SetResource.NAME = B.Reference()

function SetResource:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina

	local resourceType = state[self.TYPE]
	local resourceName = state[self.NAME]

	local gameDB = peep:getDirector():getGameDB()
	local resource = gameDB:getResource(resourceName, resourceType)

	if not resource then
		return B.Status.Failure
	end

	Utility.Peep.setResource(peep, resource)
	Utility.Peep.setNameMagically(peep)

	return B.Status.Success
end

return SetResource
