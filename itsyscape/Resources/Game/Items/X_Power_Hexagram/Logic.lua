--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Power_Hexagram/Logic.lua
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

local Hexagram = Class(ProxyXWeapon)

function Hexagram:perform(peep, target)
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

function Hexagram:getProjectile()
	return "Power_Hexagram"
end

return Hexagram
