--------------------------------------------------------------------------------
-- Resources/Game/Actions/Debug_Ascend.lua
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

local Activate = Class(Action)
Activate.SCOPES = { ['self'] = true }

function Activate:getIsDefensive()
	local gameDB = self:getGameDB()
	local brochure = gameDB:getBrochure()

	for requirement in brochure:getRequirements(self.action) do
		local resource = brochure:getConstraintResource(requirement)
		if resource.name:lower() == "defense" then
			return true
		end
	end
	
	return false
end

function Activate:perform(state, player, target)
	if not self:canPerform(state) or not self:canTransfer(state) then
		return false
	end

	local s = Utility.Peep.getEquippedShield(player, true)
	if self:getIsDefensive() and not Utility.Peep.getEquippedShield(player, true) then
		print("is defensive", s)
		return false
	end

	self:transfer(state, player)

	return true
end

function Activate:getFailureReason(state, player)
	local reason = Action.getFailureReason(self, state, player)

	if self:getIsDefensive() then
		table.insert(reason.requirements, {
			type = "Item",
			resource = "BronzeShield",
			name = "Shield",
			count = 1
		})
	end

	return reason
end

return Activate
