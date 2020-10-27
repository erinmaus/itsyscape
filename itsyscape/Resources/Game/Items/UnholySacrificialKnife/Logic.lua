--------------------------------------------------------------------------------
-- Resources/Game/Items/UnholySacrificialKnife/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local Dagger = require "Resources.Game.Items.Common.Dagger"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

local UnholySacrificialKnife = Class(Dagger)

function UnholySacrificialKnife:onEquip(peep)
	local gameDB = peep:getDirector():getGameDB()
	local resource = gameDB:getResource("UnholySacrifice", "Effect")
	Utility.Peep.applyEffect(peep, resource, true)

	Dagger.onEquip(self, peep)
end

function UnholySacrificialKnife:getBonusForStance(peep)
	local stance = peep:getBehavior(StanceBehavior)
	if stance and stance.stance == Weapon.STANCE_AGGRESSIVE then
		return Weapon.BONUS_STAB
	else
		return Weapon.BONUS_SLASH
	end
end

function UnholySacrificialKnife:getCooldown()
	return 1.0
end

return UnholySacrificialKnife
