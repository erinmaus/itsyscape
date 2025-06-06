--------------------------------------------------------------------------------
-- Resources/Game/Actions/Open.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local Action = require "ItsyScape.Peep.Action"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"

local Open = Class(Action)
Open.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }

function Open:canPerform(state, flags, prop)
	if Action.canPerform(self, state, flags) and Action.canTransfer(self, state, flags) then
		if prop:isCompatibleType(require "Resources.Game.Peeps.Props.BasicDoor") then
			return true
		end
	end

	return false
end

function Open:perform(state, player, prop, channel)
	local flags = { ['item-inventory'] = true }
	if self:canPerform(state, flags, prop) then
		if prop:isCompatibleType(require "Resources.Game.Peeps.Props.BasicDoor") then
			if prop:getIsOpen() then
				return true
			end

			if not prop:canOpen() then
				return false
			end
		end

		local i, j, k = Utility.Peep.getTileAnchor(prop, 0, 0)
		local s, t, r = Utility.Peep.getTileAnchor(player)
		local distance = math.sqrt((s - i) ^ 2 + (j - t) ^ 2)
		local walk
		if not channel then
			walk = Utility.Peep.getWalk(
				player,
				i, j, k, 2,
				{ canUseObjects = true, asCloseAsPossible = false })
		end

		if (walk or distance < 3 or not channel) and k == r then
			local open = CallbackCommand(function()
				local movement = player:getBehavior(MovementBehavior)
				movement.acceleration = Vector.ZERO
				movement.velocity = Vector.ZERO

				self:transfer(state, player, flags)
				prop:poke('open', player)
			end)
			local wait = WaitCommand(1)
			local perform = CallbackCommand(Action.perform, self, state, player, { prop = prop })
			local command = CompositeCommand(true, walk, open, perform, wait)

			local queue = player:getCommandQueue(channel)
			return queue:push(command)
		else
			return self:failWithMessage(player, "ActionFail_Walk")
		end
	end

	return false
end

function Open:getFailureReason(state, peep, prop, channel)
	local reason = Action.getFailureReason(self, state, peep)

	local s, r = prop:canOpen()
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

return Open
