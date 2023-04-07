--------------------------------------------------------------------------------
-- ItsyScape/Peep/Effects/CombatEffect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Effect = require "ItsyScape.Peep.Effect"

local CombatEffect = Class(Effect)

-- Modifies an damage roll, assuming 'damageRoll' is from self damaging the
-- target.
--
-- damageRoll is a ItsyScape.Game.Weapon.CombatRoll
--
-- purpose corresponds to a Weapon PURPOSE_* enum.
function CombatEffect:applySelfToDamage(damageRoll, purpose)
	-- Nothing.
end

-- Modifies an damage roll, assuming 'damageRoll' is from target damaging self.
--
-- damageRoll is a ItsyScape.Game.Weapon.CombatRoll
--
-- purpose corresponds to a Weapon PURPOSE_* enum.
function CombatEffect:applyTargetToDamage(damageRoll)
	-- Nothing.
end

-- Modifies an attack roll, assuming 'attackRoll' is from self attacking the
-- target.
--
-- attackRoll is a ItsyScape.Game.Weapon.AttackRoll
function CombatEffect:applySelfToAttack(attackRoll)
	-- Nothing.
end

-- Modifies an attack roll, assuming 'attackRoll' is from target attacking self.
--
-- attackRoll is a ItsyScape.Game.Weapon.AttackRoll
function CombatEffect:applyTargetToAttack(attackRoll)
	-- Nothing.
end

-- Modifies a weapon cooldown from self vs a target, either increasing or decreasing it.
function CombatEffect:applyToSelfWeaponCooldown(peep, cooldown)
	return cooldown
end

-- Modifies a weapon cooldown from target vs self, either increasing or decreasing it.
function CombatEffect:applyToTargetWeaponCooldown(target, cooldown)
	return cooldown
end

-- Modifies the weapon range from self vs a target.
function CombatEffect:applyToSelfWeaponRange(peep, range)
	return range
end

-- Modifies the weapon range from target vs self.
function CombatEffect:applyToTargetWeaponRange(peep, range)
	return range
end

return CombatEffect
