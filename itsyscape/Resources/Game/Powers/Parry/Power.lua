--------------------------------------------------------------------------------
-- Resources/Game/Powers/Parry/Power.lua
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

local Parry = Class(CombatPower)

function Parry:new(...)
	CombatPower.new(self, ...)

	local gameDB = self:getGame():getGameDB()
	self.effectResource = gameDB:getResource("Power_Parry", "Effect")
end

function Parry:activate(activator, target)
	CombatPower.activate(self, activator, target)
	Utility.Peep.applyEffect(activator, self.effectResource, true, activator)
	Utility.Combat.deflectPendingPower(self, activator, target)
end

return Parry
