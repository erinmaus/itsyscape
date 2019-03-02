--------------------------------------------------------------------------------
-- Resources/Game/Powers/Nirvana/Power.lua
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

local Nirvana = Class(CombatPower)

function Nirvana:new(...)
	CombatPower.new(self, ...)

	local gameDB = self:getGame():getGameDB()
	self.effectResource = gameDB:getResource("Power_Nirvana", "Effect")
end

function Nirvana:activate(activator, target)
	CombatPower.activate(self, activator, target)

	Utility.Peep.applyEffect(activator, self.effectResource, true, activator)
end

return Nirvana
