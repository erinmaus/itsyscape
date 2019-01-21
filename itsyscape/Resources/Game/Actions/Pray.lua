--------------------------------------------------------------------------------
-- Resources/Game/Actions/Pray.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Action = require "ItsyScape.Peep.Action"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local Pray = Class(Action)
Pray.SCOPES = { ['prayer'] = true }

function Pray:perform(state, peep)
	if not self:canPerform(state) then
		return false
	end

	local status = peep:getBehavior(CombatStatusBehavior)
	if status.currentPrayer <= 0 then
		Log.warn("No prayer points.")

		return false
	end

	local gameDB = peep:getDirector():getGameDB()
	local brochure = gameDB:getBrochure()

	local resource
	for r in brochure:findResourcesByAction(self:getAction()) do
		local resourceType = brochure:getResourceTypeFromResource(r)
		if resourceType.name == "Effect" then
			resource = r
			break
		end
	end

	if not resource then
		Log.warn("Pray action not bound to Effect resource.")
		return false
	end

	Log.info("Toggling prayer '%s'.", Utility.getName(resource, gameDB))

	Utility.Peep.toggleEffect(peep, resource)
	Action.perform(self, state, peep)

	return true
end

return Pray
