--------------------------------------------------------------------------------
-- Resources/Game/Powers/Deflect/Power.lua
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

local Deflect = Class(CombatPower)

function Deflect:new(...)
	CombatPower.new(self, ...)

	local gameDB = self:getGame():getGameDB()
	self.effectResource = gameDB:getResource("Power_Deflect", "Effect")
end

function Deflect:activate(activator, target)
	CombatPower.activate(self, activator, target)
	Utility.Peep.applyEffect(activator, self.effectResource, true, activator)
end

return Deflect
