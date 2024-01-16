--------------------------------------------------------------------------------
-- Resources/Game/Items/SurgeonsScalpel/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local Dagger = require "Resources.Game.Items.Common.Dagger"

local Scalpel = Class(Dagger)

function Scalpel:getBonusForStance(peep)
	return Weapon.BONUS_SLASH
end

function Scalpel._isFleshy(target)
	local resource = Utility.Peep.getResource(target)
	if not resource then
		return false
	end

	if resource.name == "EmptyRuins_DragonValley_FleshyPillar" then
		return true
	end

	return false
end

function Scalpel:rollAttack(peep, target, bonus)
	local attackRoll = Dagger.rollAttack(self, peep, target, bonus)

	if Scalpel._isFleshy(target) then
		attackRoll:setAlwaysHits(true)
	end

	return attackRoll
end

function Scalpel:rollDamage(peep, purpose, target)
	local damageRoll = Dagger.rollDamage(self, peep, purpose, target)

	if Scalpel._isFleshy(target) then
		damageRoll:setMinHit(damageRoll:getMaxHit())
		damageRoll:setMaxHit(damageRoll:getMaxHit() * 2)
	end

	return damageRoll
end

return Scalpel
