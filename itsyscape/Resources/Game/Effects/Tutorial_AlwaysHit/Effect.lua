--------------------------------------------------------------------------------
-- Resources/Game/Effects/Tutorial_AlwaysHit/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Effect = require "ItsyScape.Peep.Effect"
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

-- Prevents killing foe.
local AlwaysHit = Class(CombatEffect)

function AlwaysHit:new(activator)
	CombatEffect.new(self)
end

function AlwaysHit:getBuffType()
	return Effect.BUFF_TYPE_NONE
end

function AlwaysHit:applySelfToAttack(roll)
	roll:setAlwaysHits(true)
end

return AlwaysHit
