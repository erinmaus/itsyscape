--------------------------------------------------------------------------------
-- Resources/Game/DB/Quest/CalmBeforeTheStorm/Quest.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Quest "CalmBeforeTheStorm" {
	ItsyScape.Action.QuestComplete {
		Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_IsabelleDefeated",
		Count = 1
	}
}

ItsyScape.Utility.questStep(
	"CalmBeforeTheStorm_Start",
	"CalmBeforeTheStorm_TalkedToIsabelle1"
)

ItsyScape.Utility.questStep(
	"CalmBeforeTheStorm_TalkedToIsabelle1",
	"CalmBeforeTheStorm_TalkedToGrimm1"
)

ItsyScape.Utility.questStep(
	{
		"CalmBeforeTheStorm_GotCrawlingCopper",
		"CalmBeforeTheStorm_GotTenseTin",
		"CalmBeforeTheStorm_GotAncientDriftwood",
		"CalmBeforeTheStorm_GotSquidSkull"
	},

	"CalmBeforeTheStorm_GotAllItems"
)

ItsyScape.Utility.questStep(
	"CalmBeforeTheStorm_GotAllItems",
	"CalmBeforeTheStorm_TalkedToIsabelle2"
)

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to start Calm Before the Storm.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_Start"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to talk to Isabelle before you leave.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToIsabelle1",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to talk to Advisor Grimm before you continue.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToGrimm1",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to obtain crawling copper ore.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GotCrawlingCopper",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to obtain tense tin ore.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GotTenseTin",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to obtain ancient driftwood logs.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GotAncientDriftwood",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to obtain the rotten squid's skull.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GotSquidSkull",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to obtain all items requested by Isabelle.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GotAllItems",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to talk to Isabelle after obtaining all items she requested.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToIsabelle2",
}

