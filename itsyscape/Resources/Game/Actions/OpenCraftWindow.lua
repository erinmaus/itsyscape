--------------------------------------------------------------------------------
-- Resources/Game/Actions/OpenCraftWindow.lua
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

local OpenCraftWindow = Class(Action)
OpenCraftWindow.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }

function OpenCraftWindow:perform(state, player, prop)
	local game = self:getGame()
	local gameDB = game:getGameDB()
	local target = gameDB:getRecords("DelegatedActionTarget", { Action = self:getAction() })[1]
	if target then
		local key = target:get("CategoryKey")
		if key == "" then
			key = nil
		end

		local value = target:get("CategoryValue")
		if value == "" then
			value = nil
		end

		local i, j, k = Utility.Peep.getTileAnchor(prop)
		local walk = Utility.Peep.getWalk(player, i, j, k, 2.5)
		local face = CallbackCommand(Utility.Peep.face, player, prop)

		if walk then
			local open = OpenInterfaceCommand("CraftWindow", true, prop, key, value, target:get("ActionType"))
			local perform = CallbackCommand(Action.perform, self, state, player)
			local command = CompositeCommand(true, walk, face, open, perform)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		end
	end
end

return OpenCraftWindow
