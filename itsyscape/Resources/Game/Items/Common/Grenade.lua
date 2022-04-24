--------------------------------------------------------------------------------
-- Resources/Game/Items/Common/Grenade.lua
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
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"

local Grenade = Class(RangedWeapon)
Grenade.AMMO = Equipment.AMMO_THROWN
Grenade.AMMO_SLOT = Equipment.PLAYER_SLOT_RIGHT_HAND
Grenade.RADIUS_TILES = 3

function Grenade:getAttackRange()
	return 12
end

function Grenade:perform(peep, target)
	if RangedWeapon.perform(self, peep, target) then
		self:splode(peep, target)
		return true
	end

	return false
end

function Grenade:splode(peep, target)
	local targetPosition = Utility.Peep.getAbsolutePosition(target)

	local hits = peep:getDirector():probe(peep:getLayerName(), function(p)
		if p == target then
			return false
		end

		if p ~= peep and not Utility.Peep.isAttackable(p) then
			return false
		end

		local position = Utility.Peep.getAbsolutePosition(p)
		local distance = (position - targetPosition):getLength()

		return distance <= self.RADIUS_TILES * 2
	end)

	-- Hit the main target up to an additional X times if it's big enough
	do
		local size = target:getBehavior(SizeBehavior) or { size = Vector.ZERO }
		local scale = target:getBehavior(ScaleBehavior) or { scale = Vector.ONE }
		local targetSize = math.min((scale.scale * size.size):getLength() / 2, self.RADIUS_TILES - 1)
		for i = 1, targetSize do
			table.insert(hits, target)
		end
	end

	for i = 1, #hits do
		local hit = hits[i]

		-- We don't want to consume ammo for these extra hits.
		Weapon.perform(self, peep, hit)
		Log.info("Grenade hit peep '%s'.", hit:getName())
	end
end

function Grenade:getDelay(peep, target)
	return 1
end

function Grenade:getWeaponType()
	return 'grenade'
end

function Grenade:getCooldown(peep)
	return 3
end

return Grenade
