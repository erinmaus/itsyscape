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
local Equipment = require "ItsyScape.Game.Equipment"
local Power = require "ItsyScape.Game.Power"
local Utility = require "ItsyScape.Game.Utility"
local ZealEffect = require "ItsyScape.Peep.Effects.ZealEffect"

local CombatPower = Class(Power)

function CombatPower:new(...)
	Power.new(self, ...)

	self.xWeapon = false
	self.xWeaponInstance = false

	self.governingStat = false
	self.baseCost = 1
	self.maxReduction = 0
	self.minLevel = 1
	self.maxLevel = 99

	local gameDB = self:getGame():getGameDB()
	local cost = gameDB:getRecord("CombatPowerZealCost", { Resource = self:getResource() })
	if cost then
		self:setCost(
			cost:get("Skill").name,
			cost:get("BaseCost") / 100,
			cost:get("MaxReduction") / 100,
			cost:get("MinLevel"),
			cost:get("MaxLevel"))
	end
end

function CombatPower:setCost(stat, base, reduction, min, max)
	self.governingStat = stat or false
	self.baseCost = base or self.baseCost
	self.maxReduction = reduction or self.maxReduction
	self.minLevel = min or self.minLevel
	self.maxLevel = max or self.maxLevel
end

function CombatPower:setXWeaponID(id)
	self.xWeapon = id or false
end

function CombatPower:getXWeaponID()
	return self.xWeapon
end

function CombatPower:getXWeapon(peep)
	if self.xWeapon then
		local equippedWeapon = Utility.Peep.getEquippedWeapon(peep, true)
		if equippedWeapon then
			return Utility.Peep.getXWeapon(self:getGame(), self.xWeapon, equippedWeapon:getID())
		end
	end

	return nil
end

function CombatPower:getCost(peep)
	if not self.governingStat then
		return 1
	end

	local stat = peep:getState():count("Skill", self.governingStat, {
		['skill-as-level'] = true
	})

	if not stat then
		return 1
	end

	local cost
	do
		local width = self.maxLevel - self.minLevel
		if width == 0 then
			cost = self.baseCost
		else
			local difference = math.min(stat - self.minLevel, width)
			local percent = difference / width
			local reduction = math.floor(percent * self.maxReduction + 0.5)

			cost =  math.max(self.baseCost - reduction, 0)
		end

		cost = cost or 1
	end

	for effect in peep:getEffects(ZealEffect) do
		cost = effect:modifyPowerCost(self, cost)
	end

	return cost
end

return CombatPower
