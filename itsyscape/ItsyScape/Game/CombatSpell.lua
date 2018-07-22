--------------------------------------------------------------------------------
-- ItsyScape/Game/CombatSpell.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Spell = require "ItsyScape.Game.Spell"

local CombatSpell = Class(Spell)

function CombatSpell:new(...)
	Spell.new(self, ...)
end

function CombatSpell:getStrengthBonus()
	local gameDB = self:getGame():getGameDB()
	local resource = self:getResource()
	local record = gameDB:getRecords("CombatSpell", { Resource = resource }, 1)[1]
	if record then
		return record:get("Strength") or 1
	end

	return 1
end

function CombatSpell:cast(peep, target)
	self:consume(peep)
end

return CombatSpell
