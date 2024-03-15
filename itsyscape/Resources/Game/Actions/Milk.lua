--------------------------------------------------------------------------------
-- Resources/Game/Makes/Milk.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Action = require "ItsyScape.Peep.Action"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local Make = require "Resources.Game.Actions.Make"

local Milk = Class(Make)
Milk.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Milk.FLAGS = {
	['item-equipment'] = true,
	['item-inventory'] = true
}

function Milk:perform(state, player, target)
	if not (self:canPerform(state, flags) and self:canTransfer(state)) then
		return false
	end

	local i, j, k = Utility.Peep.getTileAnchor(target)
	local walk = Utility.Peep.getWalk(player, i, j, k, 2.5)
	if not walk then
		return self:failWithMessage(player, "ActionFail_Walk")
	end

	local face = CallbackCommand(Utility.Peep.face, player, target)
	local transfer = CallbackCommand(Action.transfer, self, state, player)
	local wait = WaitCommand(0.5)
	local perform = CallbackCommand(Action.perform, self, state, player)

	local queue = player:getCommandQueue()
	return queue:interrupt(CompositeCommand(nil, walk, face, transfer, perform, wait))
end

return Milk
