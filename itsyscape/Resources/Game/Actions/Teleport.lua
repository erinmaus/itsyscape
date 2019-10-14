--------------------------------------------------------------------------------
-- Resources/Game/Actions/Teleport.lua
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
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local Action = require "ItsyScape.Peep.Action"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local TeleportalBehavior = require "ItsyScape.Peep.Behaviors.TeleportalBehavior"

local Teleport = Class(Action)
Teleport.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Teleport.FLAGS ={
	['item-inventory'] = true,
	['item-equipment'] = true
}

function Teleport:perform(state, player, target)
	if target and
	   self:canPerform(state, Teleport.FLAGS) and
	   self:canTransfer(state, Teleport.FLAGS)
	then
		local i, j, k = Utility.Peep.getTile(target)
		local walk = Utility.Peep.getWalk(player, i, j, k, 2, { asCloseAsPossible = true })

		if walk then
			local teleport = CallbackCommand(self.teleport, self, state, player, target)
			local perform = CallbackCommand(Action.perform, self, state, player)
			local command = CompositeCommand(true, walk, teleport, perform)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		end
	end

	return false
end

function Teleport:teleport(state, peep, target)
	local teleportal = target:getBehavior(TeleportalBehavior)
	local position = peep:getBehavior(PositionBehavior)
	if teleportal then
		if teleportal.layer then
			position.layer = teleportal.layer
		end

		local map = peep:getDirector():getMap(position.layer)
		if map then
			local position = map:getTileCenter(teleportal.i, teleportal.j)
			position.position = position
		end

		peep:getCommandQueue():clear()
		peep:removeBehavior(TargetTileBehavior)
	end
end

return Teleport
