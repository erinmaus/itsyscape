--------------------------------------------------------------------------------
-- Resources/Game/Powers/Bash/Power.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CombatPower = require "ItsyScape.Game.CombatPower"
local PendingPowerBehavior = require "ItsyScape.Peep.Behaviors.PendingPowerBehavior"
local PowerRechargeBehavior = require "ItsyScape.Peep.Behaviors.PowerRechargeBehavior"

local Bash = Class(CombatPower)

function Bash:new(...)
	CombatPower.new(self, ...)
	self:setXWeaponID("Power_Bash")
end

function Bash:activate(activator, target)
	CombatPower.activate(self, activator, target)

	if target and target:hasBehavior(PendingPowerBehavior) then
		local pendingPower = target:getBehavior(PendingPowerBehavior)
		if pendingPower.power then
			local pendingPowerID = pendingPower.power:getResource().name

			Log.info("Bash (activated by '%s') negated pending power '%s' on target '%s'.",
				activator:getName(),
				pendingPowerID,
				target:getName())

			local rechargeCost = pendingPower.power:getCost(target)
			local _, recharge = target:addBehavior(PowerRechargeBehavior)
			recharge.powers[pendingPowerID] = math.max(recharge.powers[pendingPowerID] or 0, rechargeCost)

			target:removeBehavior(PendingPowerBehavior)
		end
	end
end

return Bash
