--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Power_BindShadow/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local ProxyXWeapon = require "ItsyScape.Game.ProxyXWeapon"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local BindShadow = Class(ProxyXWeapon)

BindShadow.DAMAGE_MULTIPLIER = 2

function BindShadow:previewAttackRoll(roll)
	roll:setAlwaysHits(true)
end

function BindShadow:rollDamage(peep, purpose, target)
	local maxTargetDamage
	if target then
		local targetWeapon = Utility.Peep.getEquippedWeapon(target, true) or Weapon()
		local targetWeaponDamageRoll = targetWeapon:rollDamage(target, Weapon.PURPOSE_KILL, target)
		maxTargetDamage = targetWeaponDamageRoll:getMaxHit() * BindShadow.DAMAGE_MULTIPLIER
	end

	local roll = ProxyXWeapon.rollDamage(self, peep, Weapon.PURPOSE_KILL, target)
	if maxTargetDamage then
		roll:setMinHit(maxTargetDamage)
		roll:setMaxHit(maxTargetDamage)
	end

	return roll
end

function BindShadow:getProjectile()
	return "Power_BindShadow"
end

return BindShadow
