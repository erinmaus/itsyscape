--------------------------------------------------------------------------------
-- Resources/Game/Powers/Keelhauler_Laser/Power.lua
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

local Laser = Class(CombatPower)

function Laser:new(...)
	CombatPower.new(self, ...)

	self:setXWeaponID("Power_Keelhauler_Laser")
end

return Laser
