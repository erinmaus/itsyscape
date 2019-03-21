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

function ProxyXWeapon:new(id, manager)
	Weapon.new(self, id, manager)

	if id then
		self.logic = manager:getLogic(id, true)
		if not self.logic:isCompatibleType(Weapon) then
			self.logic = nil
		else
			self._onAttackHit = self.logic.onAttackHit
			self.logic.onAttackHit = function(s, ...)
				self:onAttackHit(...)
			end

			self._onAttackMiss = self.logic.onAttackMiss
			self.logic.onAttackMiss = function(s, ...)
				self:onAttackMiss(...)
			end
		end
	end
end

function ProxyXWeapon:getLogic()
	return self.logic
end

function ProxyXWeapon:rollAttack(peep, target, bonus)
	if self.logic then
		return self.logic:rollAttack(peep, target, bonus)
	else
		return Weapon.rollAttack(self, peep, target, bonus)
	end
end

function ProxyXWeapon:rollDamage(peep, purpose, target)
	if self.logic then
		return self.logic:rollDamage(peep, purpose, target)
	else
		return Weapon.rollDamage(self, peep, purpose, target)
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
	if self._onAttackHit then
		self._onAttackHit(self.logic, ...)
	else
		return Weapon.onAttackHit(self, ...)
	end
end

function ProxyXWeapon:onAttackMiss(...)
	if self._onAttackMiss then
		self._onAttackMiss(self.logic, ...)
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

return ProxyXWeapon
