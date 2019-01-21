--------------------------------------------------------------------------------
-- ItsyScape/Peep/Effects/DamageEffect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Effect = require "ItsyScape.Peep.Effect"

local DamageEffect = Class(Effect)

-- Modifies an damage roll, assuming 'damageRoll' is from self damaging the
-- target.
--
-- damageRoll is a ItsyScape.Game.Weapon.DamageRoll
--
-- purpose corresponds to a Weapon PURPOSE_* enum.
function DamageEffect:applySelf(damageRoll, purpose)
	-- Nothing.
end

-- Modifies an damage roll, assuming 'damageRoll' is from target damaging self.
--
-- damageRoll is a ItsyScape.Game.Weapon.DamageRoll
--
-- purpose corresponds to a Weapon PURPOSE_* enum.
function DamageEffect:applyTarget(damageRoll)
	-- Nothing.
end

return DamageEffect
