--------------------------------------------------------------------------------
-- ItsyScape/Peep/Effects/AccuracyEffect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Effect = require "ItsyScape.Peep.Effect"

local AccuracyEffect = Class(Effect)

-- Modifies an attack roll, assuming 'attackRoll' is from self attacking the
-- target.
--
-- attackRoll is a ItsyScape.Game.Weapon.AttackRoll
function AccuracyEffect:applySelf(attackRoll)
	-- Nothing.
end

-- Modifies an attack roll, assuming 'attackRoll' is from target attacking self.
--
-- attackRoll is a ItsyScape.Game.Weapon.AttackRoll
function AccuracyEffect:applyTarget(attackRoll)
	-- Nothing.
end

return AccuracyEffect
