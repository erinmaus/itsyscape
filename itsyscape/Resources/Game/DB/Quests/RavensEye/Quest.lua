--------------------------------------------------------------------------------
-- Resources/Game/DB/Quest/RavensEye/Quest.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Quest "RavensEye" {
	ItsyScape.Action.QuestComplete() {
		Requirement {
			Resource = ItsyScape.Resource.KeyItem "RavensEye_Done",
			Count = 1
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Raven's Eye",
	Language = "en-US",
	Resource = ItsyScape.Resource.Quest "RavensEye"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Can you help Cap'n Raven find her first mate's glass eye?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Quest "RavensEye"
}

ItsyScape.Utility.questStep(
	"RavensEye_Start",
	"RavensEye_Done"
)

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to start Raven's Eye. Speak to Cap'n Raven at the Rumbridge Port pub, The Sunken Chest",
	Resource = ItsyScape.Resource.KeyItem "RavensEye_Start"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to gather the ingredients and craft Igor a glass eye.",
	Resource = ItsyScape.Resource.KeyItem "RavensEye_Done"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to gather the ingredients and craft Igor a glass eye.",
	Resource = ItsyScape.Resource.KeyItem "RavensEye_Start"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You crafted a glass eye for Igor and gave it to Cap'n Raven.",
	Resource = ItsyScape.Resource.KeyItem "RavensEye_Done"
}
