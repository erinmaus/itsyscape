--------------------------------------------------------------------------------
-- Resources/Game/Peeps/ChestMimic/Common.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Utility = require "ItsyScape.Game.Utility"

local Common = {}
function Common.spawn(mapScript, mimicAnchor, aliceAnchor, mimics, chance)
	local map = Utility.Peep.getMap(mapScript)
	if not map then
		Log.warn("No map for map script %s.", mapScript:getName())
		return false
	end

	local alice = Utility.spawnActorAtAnchor(mapScript, "ChestMimic_Alice", aliceAnchor, 0)
	if alice then
		Log.info("Spawned Alice.")
		if math.random() <= chance then
			local index
			do
				local r = math.random()
				for i = 1, #mimics do
					if r <= mimics[i].chance then
						index = i
						break
					end
				end

				index = index or 1
			end

			local mimic = Utility.spawnMapObjectAtAnchor(mapScript, mimics[index].peep, mimicAnchor)
			if mimic then
				mimic:getPeep():listen(
					'finalize',
					Utility.Peep.attack,
					mimic:getPeep(),
					alice:getPeep(),
					math.huge)
			end
		end
	end
end

return Common
