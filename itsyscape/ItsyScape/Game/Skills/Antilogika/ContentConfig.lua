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
			["Woodcutting"] = {
				constructor = "Prop",

				config = {
					min = 30,
					max = 50,
					props = {
						{
							prop = "ShadowTree_Default",
							weight = 1000,
							tier = 1
						},
						{
							prop = "AzathothianTree_Default",
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
							prop = "CommonTree_Snowy",
							weight = 1000,
							tier = 1
						},
						{
							prop = "ShadowTree_Default",
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
