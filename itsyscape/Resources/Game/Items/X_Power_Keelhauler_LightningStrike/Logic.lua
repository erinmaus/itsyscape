--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Power_Keelhauler_LightningStrike/Logic.lua
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
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"

-- Stuns opponent, dealing a minimum of 50% damage.
local LightningStrike = Class(ProxyXWeapon)

function LightningStrike:previewAttackRoll(roll)
	roll:setAlwaysHits(true)
end

function LightningStrike:previewDamageRoll(roll)
	roll:setMinHit(math.floor(roll:getMaxHit() / 2 + 0.5))
end

function LightningStrike:dealtDamage(peep, target, attack, roll)
	local maxDamage = roll:getMaxHit() + roll:getMaxHitBoost()
	local delta = math.clamp(attack:getDamage() / math.max(maxDamage, 1))

	local weapon = Utility.Peep.getEquippedWeapon(target)

	local additionalCooldown
	if weapon then
		additionalCooldown = weapon:getCooldown(target) * (1 + delta)
	else
		additionalCooldown = 4
	end

	local _, cooldown = target:addBehavior(AttackCooldownBehavior)
	cooldown.cooldown = cooldown.cooldown + additionalCooldown
	cooldown.ticks = peep:getDirector():getGameInstance():getCurrentTime()
end

function LightningStrike:getProjectile()
	return "CannonSplosion"
end

return LightningStrike
