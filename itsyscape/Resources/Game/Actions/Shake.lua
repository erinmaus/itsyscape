--------------------------------------------------------------------------------
-- Resources/Game/Actions/Shake.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local Action = require "ItsyScape.Peep.Action"
local GatheredResourceBehavior = require "ItsyScape.Peep.Behaviors.GatheredResourceBehavior"
local ForagingSkill = require "ItsyScape.Game.Skills.Foraging"

local Shake = Class(Action)
Shake.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Shake.FLAGS = { ['item-inventory'] = true, ['item-equipment'] = true }
Shake.QUEUE = {}
Shake.DURATION = 1.0

function Shake:perform(state, player, target)
	if target and self:canPerform(state) then
		local i, j, k = Utility.Peep.getTile(target)
		local asCloseAsPossible
		do
			local map = Utility.Peep.getMap(target)
			if map:getTile(i, j):hasFlag('impassable') then
				asCloseAsPossible = true
			else
				asCloseAsPossible = false
			end
		end

		local walk = Utility.Peep.getWalk(player, i, j, k, 1.5, { asCloseAsPossible = asCloseAsPossible })

		if walk then
			local transfer = CallbackCommand(self.transfer, self, state, player)
			local wait = WaitCommand(Shake.DURATION, false)
			local drop = CallbackCommand(self.drop, self, state, player, target)
			local perform = CallbackCommand(Action.perform, self, state, player)
			local command = CompositeCommand(true, walk, wait, transfer, perform, drop)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		end
	end

	return false
end

function Shake:drop(state, player, target)
	if not target:hasBehavior(GatheredResourceBehavior) then
		local gatherActionTable, totalWeight = ForagingSkill.materializeGatherActionTable(player, target)
		Log.info(
			"Number of gather actions & loot: %d (total weight: %d).",
			#gatherActionTable, totalWeight)

		for i = 1, #gatherActionTable do
			Log.info("Gather action %d weight: %d.", i, gatherActionTable[i].weight)
		end

		for i = 1, #gatherActionTable do
			local weight = math.random(0, totalWeight)

			local action = gatherActionTable[1].instance
			local actionIndex = 1
			do
				local currentWeight = gatherActionTable[1].weight
				for j = 2, #gatherActionTable do
					if currentWeight > weight then
						break
					end

					local nextAction = gatherActionTable[j]
					local nextActionWeight = nextAction.weight
					local nextWeight = currentWeight + nextActionWeight

					action = nextAction.instance
					actionIndex = j
					currentWeight = nextWeight
				end
			end

			Log.info("Selected action %d (weight: %d).", actionIndex, weight)
			action:perform(state, player, target)
		end
	else
		Log.info("Tree already shook.")
	end

	target:poke("shake")
end

return Shake
