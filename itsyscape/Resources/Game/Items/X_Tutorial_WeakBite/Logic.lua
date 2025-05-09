--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Tutorial_WeakBite/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Weapon = require "ItsyScape.Game.Weapon"
local MeleeWeapon = require "ItsyScape.Game.MeleeWeapon"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local WeakBite = Class(MeleeWeapon)

function WeakBite:getAttackRange(peep)
	return 1
end

function WeakBite:previewAttackRoll(roll)
	MeleeWeapon.previewAttackRoll(self, roll)

	local target = roll:getTarget()
	local status = target and target:getBehavior(CombatStatusBehavior)
	if status then
		local hitpointsRatio = status.currentHitpoints / status.maximumHitpoints
		if hitpointsRatio > 0.5 then
			roll:setAlwaysHits(true)
		end
	end
end

function WeakBite:previewDamageRoll(roll)
	MeleeWeapon.previewDamageRoll(self, roll)

	local target = roll:getTarget()
	local status = target and target:getBehavior(CombatStatusBehavior)
	if status and status.currentHitpoints <= math.floor(status.maximumHitpoints / 2 + 0.5) then
		roll:setDamageMultiplier(0)
	end
end

function WeakBite:getBonusForStance(peep)
	return Weapon.BONUS_STAB
end

function WeakBite:getCooldown()
	return 3
end

return WeakBite
