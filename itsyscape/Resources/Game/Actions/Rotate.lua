--------------------------------------------------------------------------------
-- Resources/Game/Actions/Rotate.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Utility = require "ItsyScape.Game.Utility"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local Action = require "ItsyScape.Peep.Action"
local Color = require "ItsyScape.Graphics.Color"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local MapResourceReferenceBehavior = require "ItsyScape.Peep.Behaviors.MapResourceReferenceBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local Rotate = Class(Action)
Rotate.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Rotate.FLAGS = { ['item-inventory'] = true, ['item-equipment'] = true }

function Rotate:perform(state, player, target)
	if target and self:canPerform(state) and self:canTransfer(state) then
		local i, j, k = Utility.Peep.getTile(target)
		local walk = Utility.Peep.getWalk(player, i, j, k, 2.5, { asCloseAsPossible = true })

		if walk then
			local rotate = CallbackCommand(self.rotate, self, player, target)
			local transfer = CallbackCommand(Action.transfer, self, state, player)
			local perform = CallbackCommand(Action.perform, self, state, player)
			local command = CompositeCommand(true, walk, transfer, rotate, perform)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		end
	end

	return false
end

function Rotate:rotate(player, target)
	local rotation
	do
		local rotationRecord = self:getGameDB():getRecord("RotateActionDirection", {
			Action = self:getAction()
		})

		if rotationRecord then
			rotation = Quaternion(
				rotationRecord:get("RotationX"),
				rotationRecord:get("RotationY"),
				rotationRecord:get("RotationZ"),
				rotationRecord:get("RotationW")
			)
		else
			rotation = Quaternion.IDENTITY
		end
	end

	local _, r = target:addBehavior(RotationBehavior)
	r.rotation = r.rotation * rotation

	target:poke('rotate', {
		rotation = rotation
	})
end

return Rotate
