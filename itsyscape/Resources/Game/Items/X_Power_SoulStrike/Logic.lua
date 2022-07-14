--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Power_SoulStrike/Logic.lua
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
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local SoulStrike = Class(ProxyXWeapon)

SoulStrike.STATS = {
	"Attack",
	"Strength",
	"Magic",
	"Wisdom",
	"Archery",
	"Dexterity",
	"Defense"
}

SoulStrike.STATS_DEBUFF_MAX = 30

SoulStrike.MAX_DAMAGE_MULTIPLIER = 4
SoulStrike.MIN_DAMAGE_MULTIPLIER = 2

function SoulStrike:perform(peep, target)
	local logic = self:getLogic()
	if logic then
		local statDebuffSum = 0

		local stats = target:getBehavior(StatsBehavior)
		do
			stats = stats and stats.stats
			if stats then
				Log.info("Debuffing '%s'.", target:getName())
				for i = 1, #SoulStrike.STATS do
					local skill = stats:getSkill(SoulStrike.STATS[i])
					local workingLevel = skill:getWorkingLevel()
					local debuff = math.floor(workingLevel * 0.1 + 0.5)
					local difference = workingLevel - debuff

					skill:setLevelBoost(skill:getLevelBoost() - difference)

					Log.info("Debuffed skill '%s' by %d levels.", skill:getName(), debuff)

					statDebuffSum = statDebuffSum + difference
				end
			end
		end

		local delta = math.min(statDebuffSum, SoulStrike.STATS_DEBUFF_MAX) / SoulStrike.STATS_DEBUFF_MAX
		local ratio = (SoulStrike.MAX_DAMAGE_MULTIPLIER - SoulStrike.MIN_DAMAGE_MULTIPLIER) * delta + SoulStrike.MIN_DAMAGE_MULTIPLIER

		Log.info("Damage multiplier is %d%%.", ratio * 100)

		local damageRoll = logic:rollDamage(peep, Weapon.PURPOSE_KILL, target)
		logic:applyDamageModifiers(damageRoll)

		local maxHit = damageRoll:getMaxHit()
		local hit = math.floor(math.max(maxHit * ratio, 1) + 0.5)

		damageRoll:setMinHit(hit)
		damageRoll:setMaxHit(hit)

		local attack = AttackPoke({
			attackType = self:getBonusForStance(peep):lower(),
			weaponType = self:getWeaponType(),
			damage = damageRoll:roll(),
			aggressor = peep
		})

		target:poke('receiveAttack', attack)
		peep:poke('initiateAttack', attack)

		local stage = peep:getDirector():getGameInstance():getStage()
		stage:fireProjectile("SoulStrike", peep, target)
	else
		return ProxyXWeapon.perform(self, peep, target)
	end
end

return SoulStrike
