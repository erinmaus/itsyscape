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
local Action = require "ItsyScape.Peep.Action"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"

local OpenCraftWindow = Class(Action)
OpenCraftWindow.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }

function OpenCraftWindow:perform(state, player, target)
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

		self:getGame():getUI():openBlockingInterface("CraftWindow", key, value, target:get("ActionType"))
	end
end

return OpenCraftWindow
