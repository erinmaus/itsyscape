--------------------------------------------------------------------------------
-- Resources/Game/Actions/Travel.lua
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
local AntilogikaInstanceBehavior = require "ItsyScape.Peep.Behaviors.AntilogikaInstanceBehavior"
local AntilogikaTravelAnchorBehavior = require "ItsyScape.Peep.Behaviors.AntilogikaTravelAnchorBehavior"

local Travel = Class(Action)
Travel.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Travel.FLAGS ={
	['item-inventory'] = true,
	['item-equipment'] = true
}

function Travel:perform(state, player, target)
	if target and
	   self:canPerform(state, Travel.FLAGS) and
	   self:canTransfer(state, Travel.FLAGS)
	then
		local i, j, k = Utility.Peep.getTile(target)
		local walk = Utility.Peep.getWalk(player, i, j, k, 2.5, { asCloseAsPossible = true })

		if walk then
			local travel = CallbackCommand(self.travel, self, state, player, target)
			local perform = CallbackCommand(Action.perform, self, state, player)
			local command = CompositeCommand(true, walk, travel, perform)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		end
	end

	return false
end

function Travel:travel(state, peep, target)
	local mapScript = Utility.Peep.getMapScript(peep)
	local antilogikaInstance = mapScript:getBehavior(AntilogikaInstanceBehavior)

	if not antilogikaInstance or not antilogikaInstance.instanceManager then
		Log.warn("No Antilogika instance manager associated with map '%s'.", mapScript:getFilename())
		return
	end

	local anchor = target:getBehavior(AntilogikaTravelAnchorBehavior)
	if not anchor then
		Log.warn("Prop does not have anchor.")
		return
	end

	local instance = antilogikaInstance.instanceManager:instantiate(anchor.targetCellI, anchor.targetCellJ)

	local stage = self:getGame():getStage()
	stage:movePeep(peep, instance, anchor.targetPosition)

	peep:getCommandQueue():clear()
	peep:removeBehavior(TargetTileBehavior)

	local movement = peep:getBehavior(MovementBehavior)
	if movement then
		movement.velocity = Vector.ZERO
		movement.acceleration = Vector.ZERO
	end
end

return Travel
