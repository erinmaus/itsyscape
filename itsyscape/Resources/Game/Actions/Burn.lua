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

	local EffectType
	do
		local EffectTypeName = string.format("Resources.Game.Effects.%s", effect.name)
		local s, r = pcall(require, EffectTypeName)
		if not s then
			Log.error("Effect type '%s' not found: %s", EffectTypeName, r)
			return false
		end

		EffectType = r
	end

	if peep:getEffect(EffectType) then
		Log.info("Effect '%s' already applied.", Utility.getName(effect, gameDB))
		return false
	end

	local effectInstance = EffectType()
	peep:addEffect(effectInstance)

	self:transfer(state, peep)

	return true
end

return Burn
