--------------------------------------------------------------------------------
-- Resources/Game/Powers/Keelhauler_LightningStrike/Power.lua
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

local LightningStrike = Class(CombatPower)
LightningStrike.MIN_STRIKES = 3
LightningStrike.MAX_STRIKES = 5

function LightningStrike:new(...)
	CombatPower.new(self, ...)

	self:setXWeaponID("Power_Keelhauler_LightningStrike")
end

function LightningStrike:activate(activator, target)
	CombatPower.activate(self, activator, target)

	local stage = activator:getDirector():getGameInstance():getStage()
	stage:fireProjectile("StormLightning", activator, target)

	for i = 1, love.math.random(self.MIN_STRIKES, self.MAX_STRIKES) do
		stage:fireProjectile("StormLightning", activator, target)
	end
end

return LightningStrike
