--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Power_Earthquake/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ProxyXWeapon = require "ItsyScape.Game.ProxyXWeapon"
local Utility = require "ItsyScape.Game.Utility"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local Earthquake = Class(ProxyXWeapon)

function Earthquake:perform(peep, target)
	self:hitSurroundingPeeps(peep, target)
	return true
end

function Earthquake:hitSurroundingPeeps(peep, target)
	local range
	do
		local size = target:getBehavior(SizeBehavior)
		if size then
			size = size.size
			range = math.max(size.x, size.z) + self:getAttackRange() * 2
		else
			range = self:getAttackRange() * 2
		end
	end

	local targetPosition = Utility.Peep.getAbsolutePosition(target)

	local hits = peep:getDirector():probe(peep:getLayerName(), function(p)
		if peep == p then
			return false
		end

		if not Utility.Peep.isAttackable(p) then
			return false
		end

		local targetPosition = Utility.Peep.getAbsolutePosition(p)
		return (targetPosition - targetPosition):getLength() <= range
	end)

	for i = 1, #hits do
		ProxyXWeapon.perform(self, peep, hits[i])
	end
end

function Earthquake:getProjectile()
	return "Power_Earthquake"
end

return Earthquake
