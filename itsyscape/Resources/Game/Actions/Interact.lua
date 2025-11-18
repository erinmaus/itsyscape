--------------------------------------------------------------------------------
-- Resources/Game/Actions/Interact.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Function = require "ItsyScape.Common.Function"
local Utility = require "ItsyScape.Game.Utility"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local Action = require "ItsyScape.Peep.Action"
local Color = require "ItsyScape.Graphics.Color"
local QueueWalkCommand = require "ItsyScape.Peep.QueueWalkCommand"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local MapResourceReferenceBehavior = require "ItsyScape.Peep.Behaviors.MapResourceReferenceBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local Interact = Class(Action)
Interact.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Interact.FLAGS = { ['item-inventory'] = true, ['item-equipment'] = true }

local function both(f1, f2)
	return f1() and f2()
end

function Interact:perform(state, player, target)
	local actor = player:getBehavior(ActorReferenceBehavior)
	if not actor or not actor.actor then
		return false
	end

	if target and self:canPerform(state) and self:canTransfer(state) then
		local i, j, k = Utility.Peep.getTileAnchor(target)
		local walk, n = Utility.Peep.queueWalk(player, i, j, k, self.MAX_DISTANCE or 1.5)

		walk:register(function(s)
			if not s then
				self:failWithMessage(player, "ActionFail_Walk")
				return
			end

			local name = self:getGameDB():getRecord("NamedPeepAction", {
				Action = self:getAction()
			})

			local e = {
				name = name and name:get("Name") or false,
				peep = player,
				action = self,
				target = target
			}

			local face = CallbackCommand(Utility.Peep.face, player, target)
			local transfer = CallbackCommand(Action.transfer, self, state, player)
			local perform = CallbackCommand(Action.perform, self, state, player)
			local canPerform = Function(both, Function(self.canPerform, self, state), Function(self.canTransfer, self, state))
			local poke = target and CallbackCommand(target.poke, target, "interact", e) or Function.EMPTY

			local queue = player:getCommandQueue()
			if not queue:push(CompositeCommand(canPerform, face, transfer, perform, poke)) then
				self:fail(state, player)
			end
		end)

		return player:getCommandQueue():interrupt(QueueWalkCommand(walk, n))
	end

	return false
end

return Interact
