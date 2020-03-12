--------------------------------------------------------------------------------
-- Resources/Game/DB/Sailing/FirstMates.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Nyan = ItsyScape.Resource.Peep "Sailing_Nyan" {
		ItsyScape.Action.SailingBuy() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = ItsyScape.Utility.xpForLevel(15)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Coins",
				Count = 300000
			},

			Input {
				Resource = ItsyScape.Resource.Item "BoneShards",
				Count = 1000
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Sailors.Nyan",
		Resource = Nyan
	}

	ItsyScape.Meta.Peep {
		Singleton = 1,
		SingletonID = "Sailing_Nyan",
		Resource = Nyan
	}

	ItsyScape.Meta.ResourceName {
		Value = "Nyan",
		Language = "en-US",
		Resource = Nyan
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Perhaps the smartest dog to sail the Five Seas.",
		Language = "en-US",
		Resource = Nyan
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Species",
		Value = "Dog",
		Resource = Meta.TYPE_TEXT
	}

	ItsyScape.Meta.SailingCrewClass {
		Value = ItsyScape.Utility.Weapon.STYLE_MELEE,
		Resource = Nyan
	}
end
