--------------------------------------------------------------------------------
-- Resources/Game/Items/Common/Musket.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local RangedWeapon = require "ItsyScape.Game.RangedWeapon"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local Musket = Class(RangedWeapon)
Musket.AMMO = Equipment.AMMO_BULLET
Musket.RADIUS = 8
Musket.HIT_SIZE = 2

function Musket:getAttackRange()
	return 10
end

function Musket:perform(peep, target)
	local peepPosition = Utility.Peep.getAbsolutePosition(peep)
	local targetPosition = Utility.Peep.getAbsolutePosition(target)
	local direction = (targetPosition - peepPosition):getNormal()

	local ray = Ray(peepPosition, direction)
	local hits = peep:getDirector():probe(
		peep:getLayerName(),
		self:probe(ray, peep, target))

	if self:shoot(peep, target, true) then
		for _, hit in ipairs(hits) do
			self:shoot(peep, hit, false)
		end

		return true
	end

	return false
end

function Musket:probe(ray, peep, target)
	return function(p)
		if p == peep or p == target then
			return false
		end

		if not Utility.Peep.canPeepAttackTarget(peep, p) then
			return false
		end

		local peepRadius
		do
			local size = Utility.Peep.getSize(p)
			peepRadius = math.max(size.x, size.z) / 2
		end

		local length = self:getAttackRange(peep) * 2
		local position = Utility.Peep.getAbsolutePosition(p)
		local distance = Vector.dot(position - ray.origin, ray.direction)
		do
			local isBehind = distance <= -peepRadius
			local isTooFar = distance >= length + peepRadius

			if isBehind or isTooFar then
				return false
			end
		end

		local radiusAtPosition = distance / length * self.RADIUS
		local orthogonalDistance = ((position - ray.origin) - (distance * ray.direction)):getLength()
		do
			local isOutside = orthogonalDistance > (radiusAtPosition + peepRadius)
			if isOutside then
				return false
			end
		end

		return true
	end
end

function Musket:shoot(peep, target, consumeAmmo)
	local numHits
	do
		local size = Utility.Peep.getSize(target)
		local length = math.sqrt(size.x ^ 2 + size.z ^ 2)

		numHits = math.floor(math.min(math.max(self.RADIUS / self.HIT_SIZE, 1), math.max(length / self.HIT_SIZE, 1)) + 0.5)
	end

	if consumeAmmo then
		if not RangedWeapon.perform(self, peep, target) then
			return false
		end

		numHits = numHits - 1
	end

	for i = 1, numHits do
		-- We don't want to consume ammo for these extra hits.
		Weapon.perform(self, peep, target)
	end

	return true
end

function Musket:getWeaponType()
	return 'musket'
end

function Musket:getCooldown(peep)
	return 2.5
end

function Musket:getProjectile(peep)
	return nil
end

return Musket
