--------------------------------------------------------------------------------
-- Resources/Game/Spells/SummonGoo/Spell.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CombatSpell = require "ItsyScape.Game.CombatSpell"
local Utility = require "ItsyScape.Game.Utility"
local SummonGooEffect = require "Resources.Game.Effects.SummonGoo.Effect"

local SummonGoo = Class(CombatSpell)

function SummonGoo:cast(peep, target)
	CombatSpell.cast(self, peep, target)

	local effect = target:getEffect(SummonGooEffect)
	if not effect then
		Utility.Peep.applyEffect(target, "SummonGoo", true)
	else
		effect:boost()
	end
end

return SummonGoo
