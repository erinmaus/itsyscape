--------------------------------------------------------------------------------
-- ItsyScape/Game/CombatPower.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Power = require "ItsyScape.Game.Power"
local Utility = require "ItsyScape.Game.Utility"

local CombatPower = Class(Power)

function CombatPower:new(...)
	Power.new(self, ...)

	self.xWeapon = false
	self.xWeaponInstance = false

	self.governingStat = false
	self.baseCoolDown = math.huge
	self.maxReduction = 0
	self.minLevel = 1
	self.maxLevel = 99

	local gameDB = self:getGame():getGameDB()
	local coolDown = gameDB:getRecord("CombatPowerCoolDown", {
		Resource = self:getResource()
	})

	if coolDown then
		self:setCoolDown(
			coolDown:get("Skill").name,
			coolDown:get("BaseCoolDown"),
			coolDown:get("MaxReduction"),
			coolDown:get("MinLevel"),
			coolDown:get("MaxLevel"))
	end
end

function CombatPower:setCoolDown(stat, base, reduction, min, max)
	self.governingStat = stat or false
	self.baseCoolDown = base or self.baseCoolDown
	self.maxReduction = reduction or self.maxReduction
	self.minLevel = min or self.minLevel
	self.maxLevel = max or self.maxLevel
end

function CombatPower:setXWeaponID(id)
	self.xWeapon = id or false
	self.xWeaponInstance = false
end

function CombatPower:getXWeaponID()
	return self.xWeapon
end

function CombatPower:getXWeapon()
	if self.xWeapon then
		if not self.xWeaponInstance then
			self.xWeaponInstance = Utility.Peep.getXWeapon(self:getGame(), self.xWeapon)
		end
	end

	return self.xWeaponInstance
end

function CombatPower:getCoolDown(peep)
	if self.governingStat then
		local stat = peep:getState():count("Skill", self.governingStat, {
			['skill-as-level'] = true
		})

		if stat then
			local width = self.maxLevel - self.minLevel
			if width == 0 then
				return self.baseCoolDown
			end

			local difference = stat - self.minLevel
			local percent = difference / width
			local reduction = math.floor(percent * self.maxReduction + 0.5)

			return math.max(self.baseCoolDown - reduction, 1)
		end
	end

	return math.huge
end

return CombatPower
