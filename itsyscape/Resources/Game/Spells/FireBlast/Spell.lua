--------------------------------------------------------------------------------
-- Resources/Game/Spells/FireBlast/Spell.lua
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
local FireStrikeEffect = require "Resources.Game.Effects.FireStrike.Effect"

local FireBlast = Class(CombatSpell)

function FireBlast:cast(peep, target)
	CombatSpell.cast(self, peep, target)

	local effect = target:getEffect(FireStrikeEffect)
	if not effect then
		local s, e = Utility.Peep.applyEffect(target, "FireStrike", true)
		if s then
			e:boost(true)
		end
	else
		effect:boost(true)
	end
end

return FireBlast
