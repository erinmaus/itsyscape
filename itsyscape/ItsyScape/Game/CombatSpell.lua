--------------------------------------------------------------------------------
-- ItsyScape/Game/CombatSpell.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Spell = require "ItsyScape.Game.Spell"

local CombatSpell = Class(Spell)

CombatSpell.DEFAULT_STRENGTH_BONUS = 1
CombatSpell.DEFAULT_ZEAL_COST      = 0.1

function CombatSpell:new(...)
	Spell.new(self, ...)

	self.strengthBonus = self.DEFAULT_STRENGTH_BONUS
	self.zealCost = self.DEFAULT_ZEAL_COST

	local gameDB = self:getGame():getGameDB()
	local resource = self:getResource()
	local record = gameDB:getRecord("CombatSpell", { Resource = resource }, 1)
	if record then
		self.strengthBonus = record:get("Strength")
		self.zealCost = record:get("ZealCost")
	end
end

function CombatSpell:getStrengthBonus()
	return self.strengthBonus
end

function CombatSpell:applyDamageRoll(damageRoll)
	-- Nothing
end

function CombatSpell:applyAccuracyRoll(accuracyRoll)
	-- Nothing
end

function CombatSpell:getBonusForStance(peep)
	return nil
end

function CombatSpell:getProjectile(peep)
	return self:getResource().name
end

function CombatSpell:getZealCost(peep)
	return self.zealCost
end

function CombatSpell:cast(peep, target)
	self:consume(peep)
	self:transfer(peep)
end

return CombatSpell
