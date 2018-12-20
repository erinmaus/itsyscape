--------------------------------------------------------------------------------
-- Resources/Game/Actions/OpenShop.lua
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
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local OpenInterfaceCommand = require "ItsyScape.UI.OpenInterfaceCommand"
local Action = require "ItsyScape.Peep.Action"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"

local OpenShop = Class(Action)
OpenShop.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }

function OpenShop:perform(state, player, prop)
	local game = self:getGame()
	local gameDB = game:getGameDB()
	local target = gameDB:getRecords("ShopTarget", { Action = self:getAction() })[1]
	if target then
		local shop = target:get("Resource")

		local i, j, k = Utility.Peep.getTile(prop)
		local walk = Utility.Peep.getWalk(player, i, j, k, 1, { asCloseAsPossible = false })
		local face = CallbackCommand(Utility.Peep.face, player, prop)

		if walk then
			local open = OpenInterfaceCommand("ShopWindow", true, shop)
			local perform = CallbackCommand(Action.perform, self, state, player)
			local command = CompositeCommand(true, walk, face, open, perform)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		end
	end
end

return OpenShop
