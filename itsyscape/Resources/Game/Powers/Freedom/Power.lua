--------------------------------------------------------------------------------
-- Resources/Game/Powers/Freedom/Power.lua
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
local Effect = require "ItsyScape.Peep.Effect"

local Freedom = Class(CombatPower)

function Freedom:activate(activator, target)
	CombatPower.activate(self, activator, target)

	local e = {}
	for effect in activator:getEffects() do
		if effect:getBuffType() == Effect.BUFF_TYPE_NEGATIVE then
			table.insert(e, effect)
		end
	end

	if #e > 0 then
		activator:removeEffect(e[math.random(#e)])
	end
end

return Freedom
