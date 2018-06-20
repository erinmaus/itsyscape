--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/ActiveSpellBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"
local Weapon = require "ItsyScape.Game.Weapon"

-- Specifies the active spell of a Peep.
local ActiveSpellBehavior = Behavior("ActiveSpell")

-- Constructs a ActiveSpellBehavior with the provided spell.
--
-- * spell: Whether or not to use active combat spell. Defaults to false. Should
--          be an object...
--
-- Defaults to STANCE_CONTROLLED.
function ActiveSpellBehavior:new(spell)
	Behavior.Type.new(self)
	self.spell = spell or false
end

return ActiveSpellBehavior
