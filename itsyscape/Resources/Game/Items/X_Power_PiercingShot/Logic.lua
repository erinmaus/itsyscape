--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Power_PiercingShot/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Ray = require "ItsyScape.Common.Math.Ray"
local ProxyXWeapon = require "ItsyScape.Game.ProxyXWeapon"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

-- Shoots all targets along the path.
local PiercingShot = Class(ProxyXWeapon)

function PiercingShot:onAttackHit(peep, target, ...)
	local logic = self:getLogic()
	if logic then
		local roll = logic:rollDamage(peep, Weapon.PURPOSE_KILL, target)
		local maxHit = roll:getMaxHit()

		local level = peep:getState():count(
			"Skill",
			"Dexterity",
			{ ['skill-as-level'] = true })

		local scale = math.min((level / 50) * 1.5 + 0.5, 2)
		local damage = math.floor(maxHit * scale + 0.5)

		local attack = AttackPoke({
			attackType = self:getBonusForStance(peep):lower(),
			weaponType = self:getWeaponType(),
			damage = damage,
			aggressor = peep
		})

		target:poke('receiveAttack', attack)
		peep:poke('initiateAttack', attack)

		self:hitOnPath(peep, target)
	else
		return ProxyXWeapon.onAttackHit(self, peep, target)
	end
end

function PiercingShot:hitOnPath(peep, target)
	local ray, range = Utility.Peep.getTargetLineOfSight(peep, target)
	local hits = Utility.Peep.getPeepsAlongRay(peep, ray, range)

	for i = 1, #hits do
		if hits[i] ~= peep and hits[i] ~= target then
			local damage = self:rollDamage(peep, Weapon.PURPOSE_KILL, hits[i]):roll()
			local attack = AttackPoke({
				attackType = self:getBonusForStance(peep):lower(),
				weaponType = self:getWeaponType(),
				damage = damage,
				aggressor = peep
			})

			Log.info("Hit '%s' for %d damage.", hits[i]:getName(), damage)

			hits[i]:poke('receiveAttack', attack)
		end
	end
end


return PiercingShot
