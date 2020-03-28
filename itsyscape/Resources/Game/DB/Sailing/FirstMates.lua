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
	local Jenkins = ItsyScape.Resource.Peep "Sailing_Jenkins" {
		ItsyScape.Action.SailingBuy() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Coins",
				Count = 10000
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.PortmasterJenkins.PortmasterJenkins",
		Resource = Jenkins
	}

	ItsyScape.Meta.Peep {
		Singleton = 1,
		SingletonID = "Sailing_Jenkins",
		Resource = Jenkins
	}

	ItsyScape.Meta.ResourceName {
		Value = "Jenkins",
		Language = "en-US",
		Resource = Jenkins
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Won't put up a fight, but will sail you wherever you need.",
		Language = "en-US",
		Resource = Jenkins
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Species",
		Value = "Human",
		Resource = Jenkins
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "SailingRole",
		Value = "FirstMate",
		Resource = Jenkins
	}

	ItsyScape.Meta.SailingCrewClass {
		Value = ItsyScape.Utility.Weapon.STYLE_MELEE,
		Resource = Jenkins
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Peeps/Sailors/Jenkins/Jenkins_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	Jenkins {
		TalkAction
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "SailorsHat",
		Count = 1,
		Resource = Jenkins
	}
end

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
		Resource = Nyan
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "SailingRole",
		Value = "FirstMate",
		Resource = Nyan
	}

	ItsyScape.Meta.SailingCrewClass {
		Value = ItsyScape.Utility.Weapon.STYLE_MELEE,
		Resource = Nyan
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Peeps/Sailors/Nyan/Nyan_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	Nyan {
		TalkAction
	}
end
