--------------------------------------------------------------------------------
-- Resources/Game/Actions/Sleep.lua
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
local Action = require "ItsyScape.Peep.Action"
local Color = require "ItsyScape.Graphics.Color"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local MapResourceReferenceBehavior = require "ItsyScape.Peep.Behaviors.MapResourceReferenceBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local Sleep = Class(Action)
Sleep.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Sleep.FLAGS = { ['item-inventory'] = true, ['item-equipment'] = true }

function Sleep:perform(state, player, target)
	local actor = player:getBehavior(ActorReferenceBehavior)
	if not actor or not actor.actor then
		return false
	end

	local director = player:getDirector()
	local peeps = director:probe(player:getLayerName(), function(p)
		local combatTarget = p:getBehavior(CombatTargetBehavior)
		return combatTarget and combatTarget.actor == actor.actor
	end)

	if #peeps > 0 then
		Log.info("Target is under attack, cannot sleep.")
		return false
	end

	if target and self:canPerform(state) then
		local i, j, k = Utility.Peep.getTile(target)
		local walk = Utility.Peep.getWalk(player, i, j, k, 2, { asCloseAsPossible = true })

		if walk then
			local save = CallbackCommand(self.save, self, player)
			local perform = CallbackCommand(Action.perform, self, state, player)
			local command = CompositeCommand(true, walk, save, poof, perform, wait)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		end
	end

	return false
end

function Sleep:save(player)
	Utility.save(player, true, true, "Zzz...?", Color(1, 1, 1, 1))

	local status = player:getBehavior(CombatStatusBehavior)
	local stats = player:getBehavior(StatsBehavior)

	if status then
		if stats and stats.stats then
			stats = stats.stats
			status.currentHitpoints = stats:getSkill("Constitution"):getWorkingLevel()
			status.currentPrayer = stats:getSkill("Faith"):getWorkingLevel()
		else
			status.currentHitpoints = status.maximumHitpoints
			status.currentPrayer = status.maximumPrayer
		end
	end
end

return Sleep
