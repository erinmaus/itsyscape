--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/FindNearbyMapObject.lua
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

local FindNearbyMapObject = B.Node("FindNearbyMapObject")
FindNearbyMapObject.PROP = B.Reference()
FindNearbyMapObject.RESULT = B.Reference()
FindNearbyMapObject.SUCCESS = B.Local()

function FindNearbyMapObject:update(mashina, state, executor)
	local s = state[self.SUCCESS]
	if s then
		return B.Status.Success
	else
		return B.Status.Failure
	end
end

function FindNearbyMapObject:activated(mashina, state)
	local ore = state[self.RESOURCE]
	local director = mashina:getDirector()

	local p = director:probe(mashina:getLayerName(), Probe.namedMapObject(state[self.PROP]))[1]
	if p then
		state[self.SUCCESS] = true
		state[self.RESULT] = p
	else
		state[self.SUCCESS] = false
		state[self.RESULT] = nil
	end
end

function FindNearbyMapObject:deactivated(mashina, state)
	state[self.SUCCESS] = nil
	state[self.RESULT] = nil
end

return FindNearbyMapObject
