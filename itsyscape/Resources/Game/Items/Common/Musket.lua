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
Musket.NUM_RAYS = 5
Musket.RAY_WIDTH = math.pi / 4

function Musket:getAttackRange()
	return 10
end

function Musket:perform(peep, target)
	RangedWeapon.perform(self, peep, target)

	local peepPosition = Utility.Peep.getAbsolutePosition(peep)
	local targetPosition = Utility.Peep.getAbsolutePosition(target)
	local direction = (targetPosition - peepPosition):getNormal()

	for i = 1, self.NUM_RAYS do
		local delta = (i - 1) / (self.NUM_RAYS - 1) * 2 - 1
		local angle = self.RAY_WIDTH * delta

		local rotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, angle)
		local transformedDirection = rotation:transformVector(direction)

		self:shootPellet(transformedDirection, peep)
	end
end

function Musket:shootPellet(direction, peep, target)
	local ray = Ray(
		Utility.Peep.getAbsolutePosition(peep) + Vector.UNIT_Y + direction,
		direction)

	local hits = peep:getDirector():probe(peep:getLayerName(), function(p)
		if p == peep or p == target then
			return false
		end

		if not Utility.Peep.isAttackable(p) then
			return false
		end

		local position = Utility.Peep.getAbsolutePosition(p)
		local size = p:getBehavior(SizeBehavior)
		if not size then
			return false
		else
			size = size.size
		end
	
		local min = position - Vector(size.x / 2, 0, size.z / 2)
		local max = position + Vector(size.x / 2, size.y, size.z / 2)

		local s, p = ray:hitBounds(min, max)
		return s and (p - ray.origin):getLength() <= self:getAttackRange(peep) * 2
	end)

	table.sort(hits, function(a, b)
		local aPosition = Utility.Peep.getPosition(a)
		local aDistance = (aPosition - ray.origin):getLength()
		local bPosition = Utility.Peep.getPosition(b)
		local bDistance = (bPosition - ray.origin):getLength()

		return aDistance < bDistance
	end)

	local hit = hits[1]

	if hit then
		-- We don't want to consume ammo for these extra hits.
		Weapon.perform(self, peep, hit)
	end
end

function Musket:getWeaponType()
	return 'musket'
end

function Musket:getCooldown(peep)
	return 3
end

function Musket:getProjectile(peep)
	return nil
end

return Musket
