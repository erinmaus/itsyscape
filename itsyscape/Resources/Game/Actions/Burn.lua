--------------------------------------------------------------------------------
-- Resources/Game/Actions/Burn.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Action = require "ItsyScape.Peep.Action"

local Burn = Class(Action)
Burn.SCOPES = { ['inventory'] = true }
Burn.FLAGS = { ['item-inventory'] = true }

function Burn:perform(state, peep, item)
	if not self:canPerform(state) or not self:canTransfer(state) then
		return false
	end

	local gameDB = peep:getDirector():getGameDB()
	local enchantment = gameDB:getRecord("Enchantment", {
		Action = self:getAction()
	})

	if not enchantment then
		Log.warn("Burn action without enchantment.")
		return false
	end

	local effect = enchantment:get("Effect")
	if not effect then
		Log.warn("Malformed enchantment record; missing Effect field.")
		return false
	end

	if not Utility.Peep.applyEffect(peep, effect, true) then
		return false
	end

	self:transfer(state, peep)
	Action.perform(self, state, peep)

	return true
end

return Burn
