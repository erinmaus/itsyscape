--------------------------------------------------------------------------------
-- Resources/Game/Actions/LightProp.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Action = require "ItsyScape.Peep.Action"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local LightProp = Class(Action)
LightProp.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }

function LightProp:perform(state, peep, prop)
	local gameDB = self:getGame():getGameDB()
	if self:canPerform(state) then
		if not prop:isCompatibleType("Resources.Game.Peeps.Props.BasicTorch") then
			return false
		end

		if prop:isLit() then
			return true
		end

		if not prop:canLight() then
			return false
		end

		local light = CallbackCommand(self.transfer, self, peep:getState(), peep, { ['item-inventory'] = true })
		local wait = WaitCommand(LightProp.DURATION, false)

		local walk
		do
			local i, j, k = Utility.Peep.getTile(prop)
			walk = Utility.Peep.getWalk(peep, i, j + 1, k, 1, { asCloseAsPossible = true }) or
			       Utility.Peep.getWalk(peep, i, j, k, 1, { asCloseAsPossible = true })
		end

		if walk then
			local light = CallbackCommand(function()
				if self:transfer(state, player, flags) then
					prop:poke('open')
				end
			end)
			local wait = WaitCommand(1)
			local perform = CallbackCommand(Action.perform, self, state, player, { prop = prop })
			local command = CompositeCommand(true, walk, light, perform, wait)

			local queue = player:getCommandQueue()
			return queue:interrupt()
		end
	end

	return false
end

function LightProp:getFailureReason(state, peep, prop)
	local reason = Action.getFailureReason(self, state, peep)

	local s, r = prop:canLight()
	if not s then
		local gameDB = self:getGameDB()
		r = gameDB:getResource(r, "KeyItem")
		if r then
			table.insert(reason.requirements, {
				type = "KeyItem",
				resource = r.name,
				name = Utility.getName(r, gameDB) or ("*" .. r.name),
				description = Utility.getDescription(r, gameDB) or ("*" .. r.name),
				count = 1
			})
		end
	end

	return reason
end

return LightProp
