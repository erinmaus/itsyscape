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
	ItsyScape.Action.QuestComplete() {
		Requirement {
			Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_IsabelleDefeated",
			Count = 1
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Calm Before the Storm",
	Language = "en-US",
	Resource = ItsyScape.Resource.Quest "CalmBeforeTheStorm"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Can you help Isabelle rid her island of the undead?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Quest "CalmBeforeTheStorm"
}

ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_PirateEncounterInitiated"
ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GaveOrlandoFish"

ItsyScape.Utility.questStep(
	"CalmBeforeTheStorm_Start",
	"CalmBeforeTheStorm_TalkedToIsabelle1"
)

ItsyScape.Utility.questStep(
	"CalmBeforeTheStorm_TalkedToIsabelle1",
	"CalmBeforeTheStorm_TalkedToGrimm1"
)

ItsyScape.Utility.questStep(
	"CalmBeforeTheStorm_TalkedToGrimm1",
	"CalmBeforeTheStorm_GotCrawlingCopper")

ItsyScape.Utility.questStep(
	"CalmBeforeTheStorm_TalkedToGrimm1",
	"CalmBeforeTheStorm_GotTenseTin")

ItsyScape.Utility.questStep(
	"CalmBeforeTheStorm_TalkedToGrimm1",
	"CalmBeforeTheStorm_GotAncientDriftwood")

ItsyScape.Utility.questStep(
	"CalmBeforeTheStorm_TalkedToGrimm1",
	"CalmBeforeTheStorm_GotSquidSkull")

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

ItsyScape.Utility.questStep(
	"CalmBeforeTheStorm_TalkedToIsabelle2",
	"CalmBeforeTheStorm_TalkedToJenkins")

ItsyScape.Utility.questStep(
	"CalmBeforeTheStorm_TalkedToJenkins",
	"CalmBeforeTheStorm_OpenedHighChambersYendor")

ItsyScape.Utility.questStep(
	"CalmBeforeTheStorm_OpenedHighChambersYendor",
	"CalmBeforeTheStorm_MysteryBoss")

ItsyScape.Utility.questStep(
	"CalmBeforeTheStorm_MysteryBoss",
	"CalmBeforeTheStorm_IsabelleDefeated")

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

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to talk to Jenkins to leave the island.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToJenkins",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to open the High Chambers of Yendor.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_OpenedHighChambersYendor",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to find what lay at the bottom of the High Chambers of Yendor.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_MysteryBoss"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to defeat Isabelle.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_IsabelleDefeated"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You started Calm Before the Storm.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_Start"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You talked to Isabelle.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToIsabelle1",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You talked to Advisor Grimm to learn what items you need.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToGrimm1",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You obtained the crawling copper ore.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GotCrawlingCopper",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You obtained the tense tin ore.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GotTenseTin",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You obtained the ancient driftwood logs.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GotAncientDriftwood",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You obtained the the rotten squid's skull.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GotSquidSkull",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You obtained all items requested by Isabelle.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GotAllItems",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You talked to Isabelle and got your reward.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToIsabelle2",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You talked to Jenkins to leave the Island, but there was an earthquake from the direction of the Abandoned Mines. " ..
	        "Jenkins said there's a risk of a tsunami, so best wait.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToJenkins",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You opened the High Chambers of Yendor.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_OpenedHighChambersYendor",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You discovered Isabelle at the bottom of the High Chambers of Yendor.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_MysteryBoss"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You defeated Isabelle.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_IsabelleDefeated"
}
