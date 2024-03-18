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
ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_MetGrimm"
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
	Value = "Start Calm Before the Storm by speaking to Isabelle on the bottom floor of Isabelle Tower.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_Start"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Isabelle won't unlock the doors until you talk to her.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToIsabelle1",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Advisor Grimm has more information on the resources you need to obtain.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToGrimm1",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Crawling copper ore can be obtained from a ghostly miner foreman in the abandoned mines.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GotCrawlingCopper",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Tense tin ore can be obtained from a ghostly miner foreman in the abandoned mines.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GotTenseTin",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Four ancient driftwood splinters can be chopped from the ancient driftwood in the Foggy Forest.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GotAncientDriftwood",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Jenkins can help you sail to slay Mn'thrw the undead squid and obtain his ... skull?",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GotSquidSkull",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Obtain all items requested by Isabelle to continue.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GotAllItems",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Talk to Isabelle after obtaining all the items.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToIsabelle2",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Jenkins can take sail you to Rumbridge.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToJenkins",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Something in the Abandoned Mines must've caused an earthquake. Maybe talking to someone down there can help?",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_OpenedHighChambersYendor",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Something horrible resides at the bottom of the High Chambers of Yendor...",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_MysteryBoss"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Isabelle must be defeated!",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_IsabelleDefeated"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You started Calm Before the Storm.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_Start"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "After talking to Isabelle, you agreed to get her the stuff to rid the island of a curse.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToIsabelle1",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Advisor Grimm told you the list of items you need.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToGrimm1",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "The crawling copper ore from the ghostly miner foreman was handed over to Grimm.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GotCrawlingCopper",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "The tense tin ore from the ghostly miner foreman was handed over to Grimm.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GotTenseTin",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Four ancient driftwood splinters were handed over to Grimm.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GotAncientDriftwood",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "The skull of the undead squid was handed over to Grimm",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GotSquidSkull",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "All four items requested from Isabelle were turned in to Grimm.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_GotAllItems",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Isabelle gave you a modest reward for obtaining all the items and bid you well on your journey to Rumbridge.",
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
	Value = "The High Chambers of Yendor were opened...",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_OpenedHighChambersYendor",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Isabelle was at the bottom of the High Chambers of Yendor! She's out for blood.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_MysteryBoss"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Isabelle was defeated. Now it's safe to go to Rumbridge!",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_IsabelleDefeated"
}

do
	local Maggot = ItsyScape.Resource.Peep "CalmBeforeTheStorm_Maggot"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Maggot.BaseMaggot",
		Resource = Maggot
	}

	ItsyScape.Meta.ResourceName {
		Value = "Giant maggot",
		Language = "en-US",
		Resource = Maggot
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "It writhes in horror, eating at the carcass of a slain god.",
		Language = "en-US",
		Resource = Maggot
	}
end

do
	local Dream = ItsyScape.Resource.Dream "CalmBeforeTheStorm_ThroneRoom"

	ItsyScape.Meta.ResourceName {
		Value = "Yendor's Throne Room",
		Language = "en-US",
		Resource = Dream
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Yendor kindly requests your audience.",
		Language = "en-US",
		Resource = Dream
	}

	ItsyScape.Meta.DreamRequirement {
		Map = ItsyScape.Resource.Map "Dream_CalmBeforeTheStorm_ThroneRoom",
		Anchor = "Anchor_Spawn",
		KeyItem = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_IsabelleDefeated",
		Dream = ItsyScape.Resource.Dream "CalmBeforeTheStorm_ThroneRoom"
	}
end

do
	local Dream = ItsyScape.Resource.Dream "CalmBeforeTheStorm_Ship"

	ItsyScape.Meta.ResourceName {
		Value = "Rh'lor Ocean",
		Language = "en-US",
		Resource = Dream
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A near death experience.",
		Language = "en-US",
		Resource = Dream
	}

	ItsyScape.Meta.DreamRequirement {
		Map = ItsyScape.Resource.Map "Dream_CalmBeforeTheStorm_Ship",
		Anchor = "Anchor_Spawn",
		KeyItem = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_KilledBoundNymph",
		Dream = ItsyScape.Resource.Dream "CalmBeforeTheStorm_Ship"
	}
end
