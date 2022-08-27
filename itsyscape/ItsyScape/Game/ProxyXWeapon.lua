--------------------------------------------------------------------------------
-- ItsyScape/Game/ProxyXWeapon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"

local ProxyXWeapon = Class(Weapon)
ProxyXWeapon.PATCH = {
	"rollDamage",
	"rollAttack",
	"applyDamageModifiers",
	"previewDamageRoll",
	"applyAttackModifiers",
	"previewAttackRoll",
	"onAttackHit",
	"onAttackMiss",
	"getDelay"
}

function ProxyXWeapon:new(id, manager, logic)
	Weapon.new(self, id, manager)

	self.patches = {}
	if id then
		self.logic = manager:getLogic(id, true, true)
		if not self.logic:isCompatibleType(Weapon) then
			self.logic = nil
		else
			for i = 1, #ProxyXWeapon.PATCH do
				local methodName = ProxyXWeapon.PATCH[i]
				local originalMethod = self.logic[methodName]

				self.patches[methodName] = originalMethod
				self.logic[methodName] = function(s, ...)
					return self[methodName](self, ...)
				end
			end
		end
	end
end

function ProxyXWeapon:getLogic()
	return self.logic
end

function ProxyXWeapon:rollAttack(peep, target, bonus)
	if self.patches.rollAttack then
		return self.patches.rollAttack(self.logic, peep, target, bonus)
	else
		return Weapon.rollAttack(self, peep, target, bonus)
	end
end

function ProxyXWeapon:applyAttackModifiers(...)
	if self.patches.applyAttackModifiers then
		return self.patches.applyAttackModifiers(self.logic, ...)
	else
		return Weapon.applyAttackModifiers(self, ...)
	end
end

function ProxyXWeapon:previewAttackRoll(roll)
	if self.patches.previewAttackRoll then
		return self.patches.previewAttackRoll(self.logic, roll)
	else
		return Weapon.previewAttackRoll(self, roll)
	end
end

function ProxyXWeapon:rollDamage(peep, purpose, target)
	if self.patches.rollDamage then
		return self.patches.rollDamage(self.logic, peep, purpose, target)
	else
		return Weapon.rollDamage(self, peep, purpose, target)
	end
end

function ProxyXWeapon:applyDamageModifiers(...)
	if self.patches.applyDamageModifiers then
		return self.patches.applyDamageModifiers(self.logic, ...)
	else
		return Weapon.applyDamageModifiers(self, ...)
	end
end

function ProxyXWeapon:previewDamageRoll(roll)
	if self.patches.previewDamageRoll then
		return self.patches.previewDamageRoll(self.logic, roll)
	else
		return Weapon.previewDamageRoll(self, roll)
	end
end

function ProxyXWeapon:perform(peep, target)
	if self.logic then
		return self.logic:perform(peep, target)
	else
		return Weapon.perform(self, peep, target)
	end
end

function ProxyXWeapon:onAttackHit(...)
	if self.patches.onAttackHit then
		return self.patches.onAttackHit(self.logic, ...)
	else
		return Weapon.onAttackHit(self, ...)
	end
end

function ProxyXWeapon:onAttackMiss(...)
	if self.patches.onAttackMiss then
		return self.patches.onAttackMiss(self.logic, ...)
	else
		return Weapon.onAttackMiss(self, ...)
	end
end

function ProxyXWeapon:getBonusForStance(peep)
	if self.logic then
		return self.logic:getBonusForStance(peep)
	else
		return Weapon.getBonusForStance(self, peep)
	end
end

function ProxyXWeapon:getAttackRange(peep)
	if self.logic then
		return self.logic:getAttackRange(peep)
	else
		return Weapon.getAttackRange(self, peep)
	end
end

function ProxyXWeapon:getStyle(peep)
	if self.logic then
		return self.logic:getStyle()
	else
		return Weapon.getStyle(self)
	end
end

function ProxyXWeapon:getSkill(purpose)
	if self.logic then
		return self.logic:getSkill(purpose)
	else
		return Weapon.getSkill(self, purpose)
	end
end

function ProxyXWeapon:getWeaponType()
	if self.logic then
		return self.logic:getWeaponType()
	else
		return Weapon.getWeaponType(self)
	end
end

function ProxyXWeapon:getProjectile(peep)
	if self.logic then
		return self.logic:getProjectile(peep)
	else
		return Weapon.getProjectile(self, peep)
	end
end

function ProxyXWeapon:getDelay(...)
	if self.patches.getDelay then
		return self.patches.getDelay(self.logic, ...)
	else
		return Weapon.getDelay(self, ...)
	end
end

return ProxyXWeapon
