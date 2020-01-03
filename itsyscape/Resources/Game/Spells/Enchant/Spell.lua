--------------------------------------------------------------------------------
-- Resources/Game/Spells/Enchant/Spell.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local InterfaceSpell = require "ItsyScape.Game.InterfaceSpell"
local Utility = require "ItsyScape.Game.Utility"

local Enchant = Class(InterfaceSpell)
function Enchant:cast(peep)
	self:consume(peep)
	self:transfer(peep)
	Utility.UI.openInterface(peep, "CraftWindow", true, nil, "Enchanted", nil, "Enchant")
end

return Enchant
