--------------------------------------------------------------------------------
-- Resources/Game/Actions/Climb.lua
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
local QueueWalkCommand = require "ItsyScape.Peep.QueueWalkCommand"
local Action = require "ItsyScape.Peep.Action"

local Climb = Class(Action)
Climb.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Climb.FLAGS = {
	['item-inventory'] = true,
	['item-equipment'] = true
}

function Climb:perform(state, player, target)
	if target and
	   self:canPerform(state, Climb.FLAGS) and
	   self:canTransfer(state, Climb.FLAGS)
	then
		local i, j, k = Utility.Peep.getRelativeTileAnchor(target, player)
		local walk, n = Utility.Peep.queueWalk(player, i, j, k, self.MAX_DISTANCE or 1.5)
		walk:register(function(s)
			if not s then
				self:failWithMessage(player, "ActionFail_Walk")
				return
			end

			local face = CallbackCommand(Utility.Peep.face, player, target)
			local perform = CallbackCommand(Action.perform, self, state, player)
			local callback = CallbackCommand(self.travel, self, state, player, target)

			local queue = player:getCommandQueue()
			if not queue:push(CompositeCommand(nil, face, perform, callback)) then
				self:fail(state, player)
			end
		end)

		return player:getCommandQueue():interrupt(QueueWalkCommand(walk, n))
	end

	return false
end

function Climb:finish(state, peep, target, localLayer)
	Utility.Peep.enable(peep)

	local playerParentTransform = Utility.Peep.getParentTransform(peep)
	Utility.Peep.setLocalLayer(peep, localLayer)

	local newParentTransform = Utility.Peep.getParentTransform(peep)

	local absolutePosition = Utility.Peep.getPosition(peep):transform(playerParentTransform)
	local relativePosition = absolutePosition:inverseTransform(newParentTransform)
	Utility.Peep.setPosition(peep, relativePosition)
end

function Climb:travel(state, peep, target)
	local destination
	do
		local destinations = self:getGameDB():getRecords("ClimbDestination", {
			Action = self:getAction()
		})

		local playerLocalLayer = Utility.Peep.getLocalLayer(peep)
		for _, d in ipairs(destinations) do
			if d:get("FromLayer") == playerLocalLayer then
				destination = d
				break
			end
		end

		if not destination then
			return
		end
	end

	local map = Utility.Peep.getMapScript(peep)

	Utility.Peep.disable(peep)
	local cutscene = Utility.Map.playCutscene(
		map,
		destination:get("Cutscene"),
		nil,
		peep,
		{},
		target)
	cutscene:listen("done", self.finish, self, state, peep, target, destination:get("ToLayer"))
end

return Climb
