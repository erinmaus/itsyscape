--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/GetResource.lua
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

local GetResource = B.Node("GetResource")
GetResource.TYPE = B.Reference()
GetResource.NAME = B.Reference()
GetResource.PEEP = B.Reference()

function GetResource:update(mashina, state, executor)
	local type = state[self.TYPE]
	local name = state[self.NAME]
	local hits = mashina:getDirector():probe(
		mashina:getLayerName(), Probe.resource(type, name))

	if #hits > 1 then
		Log.warn("More than one hit (%d total) for resource '%s' (type: '%s').", #hits, name, type)
	end

	local hit = hits[1]
	if hit then
		state[self.PEEP] = hit
		return B.Status.Success
	else
		Log.warn("No hits found for resource '%s' (type: '%s').", name, type)
		return B.Status.Failure
	end
end

return GetResource
