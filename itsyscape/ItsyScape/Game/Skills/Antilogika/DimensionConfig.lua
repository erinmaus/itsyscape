--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/DimensionConfig.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local DimensionConfig = {
	{
		id = "Realm",

		zones = {
			{
				id = "Realm_YendorianRuins",
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
				id = "Realm_IsabelleIsland",
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
				id = "Realm_Rumbridge",
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

return DimensionConfig
