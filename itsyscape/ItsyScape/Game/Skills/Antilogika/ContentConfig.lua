--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/ContentConfig.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local ContentConfig = {
	{
		id = "Azathoth_Common",

		content = {
			["GeneralBuilding"] = {
				constructor = "Building",
				priority = 1,

				config = {
					min = 1,
					max = 2,

					buildings = {
						{
							resource = "None",
							weight = 1000,
							tier = 1
						},
						{
							resource = "Azathoth_Cabin",
							weight = 300,
							tier = 1
						}
					}
				}
			},

			["Woodcutting"] = {
				constructor = "Prop",
				priority = 10,

				config = {
					min = 30,
					max = 50,
					props = {
						{
							resource = "ShadowTree_Default",
							weight = 1000,
							tier = 1
						},
						{
							resource = "AzathothianTree_Default",
							weight = 1,
							tier = 90
						}
					}
				}
			}
		}
	},
	{
		id = "Azathoth_Icy",

		content = {
			["Woodcutting"] = {
				constructor = "Prop",

				config = {
					props = {
						{
							resource = "CommonTree_Snowy",
							weight = 1000,
							tier = 1
						},
						{
							resource = "ShadowTree_Default",
							weight = -750,
							tier = 1
						}
					}
				}
			}
		}
	}
}

return ContentConfig
