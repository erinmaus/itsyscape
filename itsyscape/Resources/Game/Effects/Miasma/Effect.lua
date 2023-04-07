--------------------------------------------------------------------------------
-- Resources/Game/Effects/Miasma/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Effect = require "ItsyScape.Peep.Effect"
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"

-- Slows the foe up to 10% for 60 seconds.
local Miasma = Class(CombatEffect)

Miasma.DURATION = 60

Miasma.INTERVAL = 0.02
Miasma.MAX_DEBUFF = 0.10

function Miasma:new()
	CombatEffect.new(self)

	self.percent = Miasma.INTERVAL
end

function Miasma:getDescription()
	return string.format("%d%%", self.percent * 100)
end

function Miasma:boost()
	self.percent = math.min(Miasma.INTERVAL + self.percent, Miasma.MAX_DEBUFF)
	self:setDuration(Miasma.DURATION)

	Log.info("Increased miasma debuff to %d%%.", self.percent * 100)
end

function Miasma:getBuffType()
	return Effect.BUFF_TYPE_NEGATIVE
end

function Miasma:applyToSelfWeaponCooldown(peep, cooldown)
	return cooldown * (1 + self.percent)
end

return Miasma
