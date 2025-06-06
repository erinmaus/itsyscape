--------------------------------------------------------------------------------
-- Resources/Game/Powers/Shockwave/Power.lua
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

local Shockwave = Class(CombatPower)

function Shockwave:new(...)
	CombatPower.new(self, ...)

	self:setXWeaponID("Power_Shockwave")
end

function Shockwave:activate(activator, target)
	CombatPower.activate(self, activator, target)

	local stage = activator:getDirector():getGameInstance():getStage()
	stage:fireProjectile("ShockwaveSplosion", activator, target)

	Utility.Combat.deflectPendingPower(self, activator, target)
end

return Shockwave
