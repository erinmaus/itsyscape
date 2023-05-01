--------------------------------------------------------------------------------
-- Resources/Game/Actions/UseCraftWindow.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Curve = require "ItsyScape.Game.Curve"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Utility = require "ItsyScape.Game.Utility"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local OpenInterfaceCommand = require "ItsyScape.UI.OpenInterfaceCommand"
local Action = require "ItsyScape.Peep.Action"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"

local UseCraftWindow = Class(Action)
UseCraftWindow.SCOPES = { ['hidden'] = true }

function UseCraftWindow:perform(state, player, prop, action, count)
	local i, j, k = Utility.Peep.getTileAnchor(prop)
	local walk = Utility.Peep.getWalk(player, i, j, k, 1.5)

	if walk then
		local craft = CallbackCommand(UseCraftWindow.delegatedPerform, self, state, player, prop, action, count)
		local perform = CallbackCommand(Action.perform, self, state, player)
		local command = CompositeCommand(true, walk, craft, perform)

		local queue = player:getCommandQueue()
		return queue:interrupt(command)
	end

	return false
end

function UseCraftWindow:delegatedPerform(state, player, prop, action, count)
	if player:getCommandQueue():clear() then
		for i = 1, count do
			action:perform(
				player:getState(),
				player,
				prop)
		end
	end
end

return UseCraftWindow
