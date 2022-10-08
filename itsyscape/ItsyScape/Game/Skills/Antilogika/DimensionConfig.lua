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
		id = "Azathoth",
		param1 = "Temperature",
		param2 = "Moisture",
		defaultID = "Azathoth_Mountain",
		zoneThreshold = 0.0,

		zones = {
			{
				id = "Azathoth_IcySea",
				content = { "Azathoth_Common", "Azathoth_Icy" },
				tileSetID = "Antilogika_AzathothIce",
				amplitude = 2,
				bedrockHeight = 4,
				cliff = "cliff",
				tiles = {
					{
						tile = "sand",
						sample = -0.8
					},
					{
						tile = "dirt",
						sample = -0.4
					},
					{
						tile = "grass_snowy",
						sample = 0.0,
					},
					{
						tile = "grass",
						sample = 0.5
					}
				}
			},
			{
				id = "Azathoth_Tundra",
				content = { "Azathoth_Common", "Azathoth_Icy" },
				tileSetID = "Antilogika_AzathothIce",
				amplitude = 1.5,
				bedrockHeight = 5,
				cliff = "cliff_brown",
				tiles = {
					{
						tile = "dirt",
						sample = -0.9
					},
					{
						tile = "rock",
						sample = -0.6
					},
					{
						tile = "snow_drift",
						sample = 0.2
					}
				}
			},
			{
				id = "Azathoth_Glacier",
				content = { "Azathoth_Common", "Azathoth_Icy" },
				tileSetID = "Antilogika_AzathothIce",
				amplitude = 0.5,
				bedrockHeight = 3,
				cliff = "cliff_glacier",
				tiles = {
					{
						tile = "ice",
						sample = -0.5
					},
					{
						tile = "snow",
						sample = 0.0
					},
					{
						tile = "snow_drift",
						sample = 0.5
					}
				}
			},
			{
				id = "Azathoth_Mountain",
				content = { "Azathoth_Common", "Azathoth_Icy" },
				tileSetID = "Antilogika_AzathothIce",
				amplitude = 2.5,
				bedrockHeight = 4,
				cliff = "cliff_brown",
				tiles = {
					{
						tile = "dirt",
						sample = -0.7
					},
					{
						tile = "rock",
						sample = -0.3,
					},
					{
						tile = "snow",
						sample = 0.0
					},
					{
						tile = "grass",
						sample = 0.3
					}
				}
			}
		}
	},
	{
		id = "Realm",
		param1 = "Temperature",
		param2 = "Moisture",
		defaultID = "Realm_IsabelleIsland",
		zoneThreshold = 0.5,

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
				},
				tiles = {
					{
						tile = "rock",
						sample = -0.5
					},
					{
						tile = "dirt",
						sample = -0.75,
					},
					{
						tile = "grass",
						sample = 0.0
					}
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
				},
				tiles = {
					{
						tile = "cave_ground",
						sample = -0.3
					},
					{
						tile = "grass",
						sample = -0.4
					}
				}
			}
		}
	}
}

return DimensionConfig
