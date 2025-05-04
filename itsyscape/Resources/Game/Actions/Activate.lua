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
local Weapon = require "ItsyScape.Game.Weapon"
local Action = require "ItsyScape.Peep.Action"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

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

	local stance = player:getBehavior(StanceBehavior)
	stance = stance and stance.stance

	if not stance then
		return false
	end

	local canUsePower
	do
		local isDefensive = self:getIsDefensive()
		if isDefensive and not (stance == Weapon.STANCE_CONTROLLED or stance == Weapon.STANCE_DEFENSIVE) then
			return self:failWithMessage(player, "ActionFail_Power_RequireDefensiveStance")
		elseif not isDefensive and not (stance == Weapon.STANCE_CONTROLLED or stance == Weapon.STANCE_AGGRESSIVE) then
			return self:failWithMessage(player, "ActionFail_Power_RequireOffensiveStance")
		end
	end

	self:transfer(state, player)

	return true
end

return Activate
