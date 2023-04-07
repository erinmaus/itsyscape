--------------------------------------------------------------------------------
-- Resources/Game/Spells/Icicle/Spell.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local CombatSpell = require "ItsyScape.Game.CombatSpell"
local Utility = require "ItsyScape.Game.Utility"

local Icicle = Class(CombatSpell)

function Icicle:cast(peep, target)
	CombatSpell.cast(self, peep, target)
	Utility.Peep.applyEffect(target, "Icicle", false, peep)
end

function Icicle:getBonusForStance(peep)
	return Weapon.BONUS_STAB
end

return Icicle
