--------------------------------------------------------------------------------
-- ItsyScape/UI/DebugSummonController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Controller = require "ItsyScape.UI.Controller"

local DebugSummonController = Class(Controller)

function DebugSummonController:new(peep, director)
	Controller.new(self, peep, director)
end

function DebugSummonController:poke(actionID, actionIndex, e)
	if actionID == "summon" then
		self:summon(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function DebugSummonController:summon(e)
	print(">>> E", Log.dump(e))
	assert(type(e.count) == "number", "count must be number")
	assert(type(e.resourceName) == "string", "resource name must be number")
	assert(type(e.resourceType) == "string", "resource type must be number")

	local state = self:getPeep():getState()

	local success
	if e.count < 0 then
		success = state:take(e.resourceType, e.resourceName, math.abs(e.count), e.flags)
	else
		success = state:give(e.resourceType, e.resourceName, math.max(e.count, 1), e.flags)
	end

	if success then
		Log.info("Summon success: %s", Log.dump(e))
	else
		Log.info("Summon failed: %s", Log.dump(e))
	end
end

return DebugSummonController
