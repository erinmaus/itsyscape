--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Power_Curse/Logic.lua
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
local AttackPoke = require "ItsyScape.Peep.AttackPoke"

local Curse = Class(ProxyXWeapon)

function Curse:perform(peep, target)
	local logic = self:getLogic()
	if logic then
		local attack = AttackPoke({
			attackType = self:getBonusForStance(peep):lower(),
			weaponType = self:getWeaponType(),
			damage = 0,
			aggressor = peep
		})

		target:poke('receiveAttack', attack)
		peep:poke('initiateAttack', attack)

		return true
	else
		return ProxyXWeapon.perform(self, peep, target)
	end
end

function Curse:getProjectile()
	return "Power_Curse"
end

return Curse
