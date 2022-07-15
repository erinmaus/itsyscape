--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Power_Nuke/Logic.lua
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

-- Shoots all targets along the path.
local Nuke = Class(ProxyXWeapon)
Nuke.MIN_DAMAGE_PERCENT = 1
Nuke.MAX_DAMAGE_PERCENT = 5
Nuke.RADIUS = 5.5

function Nuke:perform(peep, target)
	local logic = self:getLogic()
	if logic then
		local targets = self:getTargets(target)

		for i = 1, #targets do
			logic:perform(peep, targets[i])
			self:applyDebuff(peep, targets[i])
		end

		local stage = peep:getDirector():getGameInstance():getStage()
		stage:fireProjectile("Nuke", peep, target)
	end
end

function Nuke:applyDebuff(peep, target)
	local gameDB = target:getDirector():getGameDB()
	local resource = gameDB:getResource("Radioactive", "Effect")
	Utility.Peep.applyEffect(target, resource, true, peep)
end

function Nuke:getTargets(target)
	local targetPosition = Utility.Peep.getAbsolutePosition(target)

	local result = target:getDirector():probe(
		target:getLayerName(),
		function(peep)
			local peepPosition = Utility.Peep.getAbsolutePosition(peep)
			local distance = (targetPosition - peepPosition):getLength()

			local isWithinRadius = distance <= Nuke.RADIUS
			local isNotTarget = peep ~= target

			return isWithinRadius and isNotTarget
		end)
	table.insert(result, 1, target)

	return result
end

function Nuke:previewDamageRoll(roll)
	roll:setMinHit(roll:getMaxHit() * Nuke.MIN_DAMAGE_PERCENT)
	roll:setMaxHit(roll:getMaxHit() * Nuke.MAX_DAMAGE_PERCENT)
end

return Nuke
