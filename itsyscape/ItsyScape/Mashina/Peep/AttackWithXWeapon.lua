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

local AttackWithXWeapon = B.Node("AttackWithXWeapon")
AttackWithXWeapon.TARGET = B.Reference()
AttackWithXWeapon.X_WEAPON = B.Reference()
AttackWithXWeapon.PROXY_WEAPON = B.Reference()

function AttackWithXWeapon:update(mashina, state, executor)
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

	return B.Status.Success
end

return AttackWithXWeapon
