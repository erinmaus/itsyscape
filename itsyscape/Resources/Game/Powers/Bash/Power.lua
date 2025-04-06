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
local Utility = require "ItsyScape.Game.Utility"

local Bash = Class(CombatPower)

function Bash:new(...)
	CombatPower.new(self, ...)
	self:setXWeaponID("Power_Bash")
end

function Bash:activate(activator, target)
	CombatPower.activate(activator, target)

	if target and target:hasBehavior(PendingPowerBehavior) then
		local pendingPower = target:getBehavior(PendingPowerBehavior)

		Log.info("Bash (fired by '%s') negated pending power '%s' on target '%s'.",
			activator:getName(),
			pendingPower.power:getResource().name,
			target:getName())

		target:removeBehavior(PendingPowerBehavior)
	end
end

return Bash
