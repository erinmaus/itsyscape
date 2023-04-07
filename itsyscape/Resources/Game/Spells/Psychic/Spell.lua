--------------------------------------------------------------------------------
-- Resources/Game/Spells/Psychic/Spell.lua
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

local Psychic = Class(CombatSpell)

function Psychic:cast(peep, target)
	CombatSpell.cast(self, peep, target)
	Utility.Peep.applyEffect(target, "Psychic", false, peep)
end

return Psychic
