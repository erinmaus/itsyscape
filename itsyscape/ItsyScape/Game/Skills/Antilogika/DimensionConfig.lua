--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/DimensionConfig.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Color = require "ItsyScape.Graphics.Color"

local DimensionConfig = {
	{
		id = "Azathoth",
		param1 = "Temperature",
		param2 = "Moisture",
		defaultID = "Azathoth_Mountain",
		zoneThreshold = 0.0,

		atmosphere = {
			"Weather",
			"Combat",
			"AtmosphereProps"
		},

		zones = {
			{
				id = "Azathoth_IcySea",
				content = { "Azathoth_Common", "Azathoth_IcySea", "Azathoth_Icy" },
				tileSetID = "Antilogika_AzathothIce",
				amplitude = 2,
				bedrockHeight = 2.5,
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
				},
				lighting = {
					fog = {
						{
							Color = Color(33 / 255, 33 / 255, 33 / 255),
							NearDistance = 5,
							FarDistance = 10,
							FollowTarget = true
						},
						{
							Color = Color(83 / 255, 103 / 255, 108 / 255),
							NearDistance = 30,
							FarDistance = 60
						}
					},
					directional = {
						{
							Color = Color(66 / 255, 66 / 255, 132 / 255),
							Direction = { 4, 5, 4 }
						}
					},
					ambient = {
						{
							Color = Color(128 / 255, 128 / 255, 255 / 255),
							Ambience = 0.4
						}
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
				},
				lighting = {
					fog = {
						{
							Color = Color(33 / 255, 33 / 255, 33 / 255),
							NearDistance = 5,
							FarDistance = 10,
							FollowTarget = true
						},
						{
							Color = Color(83 / 255, 103 / 255, 108 / 255),
							NearDistance = 30,
							FarDistance = 60
						}
					},
					directional = {
						{
							Color = Color(66 / 255, 66 / 255, 132 / 255),
							Direction = { 4, 5, 4 }
						}
					},
					ambient = {
						{
							Color = Color(128 / 255, 128 / 255, 255 / 255),
							Ambience = 0.4
						}
					}
				}
			},
			{
				id = "Azathoth_Glacier",
				content = { "Azathoth_Common", "Azathoth_Glacier", "Azathoth_Icy" },
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
				},
				lighting = {
					fog = {
						{
							Color = Color(90 / 255, 90 / 255, 160 / 255),
							NearDistance = 30,
							FarDistance = 60
						},
						{
							Color = Color(76 / 255, 76 / 255, 180 / 255),
							NearDistance = 50,
							FarDistance = 100
						}
					},
					directional = {
						{
							Color = Color(234 / 255, 162 / 255, 33 / 255),
							Direction = { 4, 5, 4 }
						}
					},
					ambient = {
						{
							Color = Color(124 / 255, 111 / 255, 245 / 255),
							Ambience = 0.6
						}
					}
				}
			},
			{
				id = "Azathoth_Mountain",
				content = { "Azathoth_Common", "Azathoth_Mountain", "Azathoth_Icy" },
				tileSetID = "Antilogika_AzathothIce",
				amplitude = 8,
				bedrockHeight = 4,
				tileNoise = {
					persistence = 3,
					lacunarity = -1,
					octaves = 3,
					scale = 4
				},
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
				},
				lighting = {
					fog = {
						{
							Color = Color(90 / 255, 44 / 255, 160 / 255),
							NearDistance = 30,
							FarDistance = 60
						},
						{
							Color = Color(170 / 255, 76 / 255, 76 / 255),
							NearDistance = 50,
							FarDistance = 100
						}
					},
					directional = {
						{
							Color = Color(234 / 255, 162 / 255, 33 / 255),
							Direction = { 4, 5, 4 }
						}
					},
					ambient = {
						{
							Color = Color(124 / 255, 111 / 255, 145 / 255),
							Ambience = 0.6
						}
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
