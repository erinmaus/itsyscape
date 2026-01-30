--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/AttackWithXWeapon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local SpecialAttackBehavior = require "ItsyScape.Peep.Behaviors.SpecialAttackBehavior"

local AttackWithXWeapon = B.Node("AttackWithXWeapon")
AttackWithXWeapon.TARGET = B.Reference()
AttackWithXWeapon.X_WEAPON = B.Reference()
AttackWithXWeapon.PROXY_WEAPON = B.Reference()
AttackWithXWeapon.IS_SPECIAL = B.Reference()
AttackWithXWeapon.SPECIAL_ATTACK_INTERVAL = B.Reference()

function AttackWithXWeapon:update(mashina, state, executor)
	local isSpecial = state[self.IS_SPECIAL]
	local specialAttackInterval = state[self.SPECIAL_ATTACK_INTERVAL]

	local target = state[self.TARGET]
	if not target then
		return B.Status.Failure
	end

	local xWeaponName = state[self.X_WEAPON]
	if not xWeaponName then
		return B.Status.Failure
	end

	if not Utility.Peep.canPeepAttackTarget(mashina, target) then
		return B.Status.Failure
	end

	if isSpecial then
		target:addBehavior(PendingStrategyGradeBehavior)
	end

	local xWeapon = Utility.Peep.getXWeapon(
		mashina:getDirector():getGameInstance(),
		xWeaponName,
		state[self.PROXY_WEAPON] or nil)

	if not xWeapon:perform(mashina, target) then
		return B.Status.Failure
	end

	if xWeapon:getProjectile(mashina) then
		local stage = target:getDirector():getGameInstance():getStage()
		stage:fireProjectile(xWeapon:getProjectile(mashina), mashina, target)
	end

	if isSpecial then
		local _, special = peep:addBehavior(SpecialAttackBehavior)
		special.weapon = xWeapon
		special.attackInterval = specialAttackInterval or 1
	end

	return B.Status.Success
end

return AttackWithXWeapon
