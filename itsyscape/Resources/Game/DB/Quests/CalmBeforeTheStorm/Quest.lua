--------------------------------------------------------------------------------
-- Resources/Game/DB/Quest/CalmBeforeTheStorm/Quest.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

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
ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_KursedByCthulhu"
ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_MetOrlando"
ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GaveOrlandoFish"

ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_KilledBoundNymph"

local Quest = ItsyScape.Utility.Quest
local Step = ItsyScape.Utility.QuestStep

Quest "CalmBeforeTheStorm" {
	Step "CalmBeforeTheStorm_Start",
	Step "CalmBeforeTheStorm_TalkedToIsabelle1",
	Step "CalmBeforeTheStorm_TalkedToGrimm1",
	Step {
		"CalmBeforeTheStorm_GotCrawlingCopper",
		"CalmBeforeTheStorm_GotTenseTin",
		"CalmBeforeTheStorm_GotAncientDriftwood",
		"CalmBeforeTheStorm_GotSquidSkull",
	},
	Step "CalmBeforeTheStorm_GotAllItems",
	Step "CalmBeforeTheStorm_TalkedToIsabelle2",
	Step "CalmBeforeTheStorm_TalkedToJenkins",
	Step "CalmBeforeTheStorm_OpenedHighChambersYendor",
	Step "CalmBeforeTheStorm_MysteryBoss",
	Step "CalmBeforeTheStorm_IsabelleDefeated",
}

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
	Value = "You need to obtain ancient driftwood splinters.",
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

do
	local Dream = ItsyScape.Resource.Dream "CalmBeforeTheStorm_ThroneRoom"

	ItsyScape.Meta.ResourceName {
		Dream = "The Empty King's Throne Room",
		Language = "en-US",
		Resource = Dream
	}

	ItsyScape.Meta.ResourceName {
		Dream = "The Empty King kindly requests your audience.",
		Language = "en-US",
		Resource = Dream
	}

	ItsyScape.Meta.DreamRequirement {
		Map = ItsyScape.Resource.Map "Dream_CalmBeforeTheStorm_ThroneRoom",
		Anchor = "Anchor_Spawn",
		KeyItem = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_KilledBoundNymph",
		Dream = ItsyScape.Resource.Dream "CalmBeforeTheStorm_ThroneRoom"
	}
end

do
	local Dream = ItsyScape.Resource.Dream "CalmBeforeTheStorm_Ship"

	ItsyScape.Meta.ResourceName {
		Dream = "Ocean",
		Language = "en-US",
		Resource = Dream
	}

	ItsyScape.Meta.ResourceName {
		Dream = "A near death experience.",
		Language = "en-US",
		Resource = Dream
	}

	ItsyScape.Meta.DreamRequirement {
		Map = ItsyScape.Resource.Map "Dream_CalmBeforeTheStorm_Ship",
		Anchor = "Anchor_Spawn",
		KeyItem = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_IsabelleDefeated",
		Dream = ItsyScape.Resource.Dream "CalmBeforeTheStorm_Ship"
	}
end
