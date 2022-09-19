--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/Zones.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Dimensions = {
	{
		name = "Realm",

		zones = {
			{
				id = "Yendorian Ruins",
				tileSetID = "YendorianRuins",
				amplitude = 2,
				bedrockHeight = 4,
				curve = {
					0.0, 0.0,
					0.1, 0.1,
					0.1, 0.1,
					0.3, 0.3
				}
			},
			{
				id = "Isabelle Island",
				tileSetID = "GrassyPlain",
				amplitude = 3,
				bedrockHeight = 2,
				curve = {
					-1.0, -1.0,
					-1.0, -1.0,
					1.0, 1.0,
					1.0, 1.0
				}
			},
			{
				id = "Rumbridge",
				tileSetID = "RumbridgeMainland",
				amplitude = 1,
				bedrockHeight = 3,
				curve = {
					0.0, 0.0,
					0.5, 0.5,
					1.1, 1.1
				}
			}
		}
	}
}

return Dimensions
