--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Foraging.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Utility = require "ItsyScape.Game.Utility"

local Foraging = {}
Foraging.MAX_WEIGHT = 100

function Foraging.calculateWeight(foragingLevel, resourceTier, resourceFactor)
	-- As in Excel:
	-- =FLOOR(MAX(MIN($LEVEL/$TIER, 1)^$RARITY*100, 1), 1)

	local delta = math.min(foragingLevel / resourceTier, 1)
	local powerDelta = delta ^ resourceFactor

	-- Clamp it so the weight has a minimum of 1
	-- and a max of Foraging.MAX_WEIGHT
	local clampedPowerDelta = math.max(powerDelta * Foraging.MAX_WEIGHT, 1)

	-- Floor it so the calculation is integer
	return math.floor(clampedPowerDelta)
end

function Foraging.materializeGatherActionTable(player, target)
	local director = target:getDirector()
	local gameDB = director:getGameDB()
	local game = director:getGameInstance()

	local targetResource = Utility.Peep.getResource(target)
	local targetActions = Utility.getActions(game, targetResource, 'x-shake')

	local foragingLevel = player:getState():count(
		"Skill", "Foraging", { ['skill-as-level'] = true })

	local totalWeight = 0
	for i = 1, #targetActions do
		local targetAction = targetActions[i]

		local actionInstance = targetAction.instance:getAction()
		local foragingAction = gameDB:getRecord("ForagingAction", {
			Action = actionInstance
		})

		if not foragingAction then
			Log.warn("No ForagingAction record for a Gather action on resource '%s'.", target:getName())
			targetAction.foraging = false
			targetAction.weight = 1
		else
			targetAction.foraging = foragingAction
			targetAction.weight = Foraging.calculateWeight(
				foragingLevel, foragingAction:get("Tier"), foragingAction:get("Factor"))
		end

		totalWeight = totalWeight + targetAction.weight
	end

	return targetActions, totalWeight or 0
end

return Foraging
