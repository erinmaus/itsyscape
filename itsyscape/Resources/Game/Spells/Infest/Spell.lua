--------------------------------------------------------------------------------
-- Resources/Game/Spells/Infest/Spell.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local CombatSpell = require "ItsyScape.Game.CombatSpell"

local Infest = Class(CombatSpell)

function Infest:cast(peep, target)
	CombatSpell.cast(self, peep, target)

	local stat = peep:getState():count("Skill", "Wisdom", {
		['skill-as-level'] = true
	})

	local numMites = math.ceil(stat / 20)

	local position = Utility.Peep.getPosition(peep)
	local size = Utility.Peep.getSize(peep)
	for i = 1, numMites do
		local x = love.math.random() * (size.x * 2 + 4) - (size.x + 2)
		local z = love.math.random() * (size.z * 2 + 4) - (size.z + 2)
		local mite = Utility.spawnActorAtPosition(peep, "ShadowMite", x + position.x, position.y, z + position.z, 0)
		if mite then
			mite:getPeep():listen('finalize', function(p)
				Utility.Peep.attack(p, target)
			end)
		end
	end

	Log.info("Spawned %d mites.", numMites)
end

return Infest
