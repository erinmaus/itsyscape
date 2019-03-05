--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Power_Tornado/Logic.lua
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

-- Shoots two arrows. If the first attack hits, so does the second.
local Tornado = Class(ProxyXWeapon)

function Tornado:perform(peep, target)
	for i = 1, 2 do
		ProxyXWeapon.perform(self, peep, target)
	end

	self:hitSurroundingPeeps(peep, target)
end

function Tornado:hitSurroundingPeeps(peep, target)
	local range = self:getAttackRange(peep) * 2
	local sourcePosition = Utility.Peep.getAbsolutePosition(peep)

	local hits = peep:getDirector():probe(peep:getLayerName(), function(p)
		if peep == p or target == p then
			return false
		end

		local targetPosition = Utility.Peep.getAbsolutePosition(p)
		return (targetPosition - sourcePosition):getLength() <= range
	end)

	for i = 1, #hits do
		ProxyXWeapon.perform(self, peep, hits[i])
	end
end

function Tornado:getProjectile()
	return "Power_Tornado"
end

return Tornado
