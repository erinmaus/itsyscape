--------------------------------------------------------------------------------
-- Resources/Game/Powers/Nuke/Power.lua
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

local Nuke = Class(CombatPower)

function Nuke:new(...)
	CombatPower.new(self, ...)

	self:setXWeaponID("Power_Nuke")
end

return Nuke
