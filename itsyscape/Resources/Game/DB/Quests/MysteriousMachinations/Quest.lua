--------------------------------------------------------------------------------
-- Resources/Game/DB/Quest/MysteriousMachinations/Quest.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Quest "MysteriousMachinations" {
	ItsyScape.Action.QuestStart() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Wisdom",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Foraging",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Output {
			Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_Start",
			Count = 1
		}
	},

	ItsyScape.Action.QuestComplete() {
		Requirement {
			Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_ReportedDrakkensonToHex",
			Count = 1
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Mysterious Machinations",
	Language = "en-US",
	Resource = ItsyScape.Resource.Quest "MysteriousMachinations"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Can you help Hex build a stable portal to Azathoth?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Quest "MysteriousMachinations"
}

ItsyScape.Utility.questStep(
	"MysteriousMachinations_Start",
	"MysteriousMachinations_FindRuinsNearLeafyLake"
)

ItsyScape.Utility.questStep(
	"MysteriousMachinations_FindRuinsNearLeafyLake",
	"MysteriousMachinations_PulledRuinsIntoExistence"
)

ItsyScape.Utility.questStep(
	"MysteriousMachinations_PulledRuinsIntoExistence",
	"MysteriousMachinations_ConfiguredAncientLightMatrix")

ItsyScape.Utility.questStep(
	"MysteriousMachinations_ConfiguredAncientLightMatrix",
	"MysteriousMachinations_TalkToHex1")

ItsyScape.Utility.questStep(
	"MysteriousMachinations_TalkToHex1",
	"MysteriousMachinations_CleanAntenna")

ItsyScape.Utility.questStep(
	"MysteriousMachinations_CleanAntenna",
	"MysteriousMachinations_TalkToHex2")

ItsyScape.Resource.KeyItem "MysteriousMachinations_EnteredAzathoth"

ItsyScape.Utility.questStep(
	"MysteriousMachinations_TalkToHex2",
	"MysteriousMachinations_FoundEldritchRuins")

ItsyScape.Utility.questStep(
	"MysteriousMachinations_FoundEldritchRuins",
	"MysteriousMachinations_CraftAzathothianSpacialRune")

ItsyScape.Utility.questStep(
	"MysteriousMachinations_CraftAzathothianSpacialRune",
	"MysteriousMachinations_TalkToKvre")

ItsyScape.Utility.questStep(
	"MysteriousMachinations_TalkToKvre",
	"MysteriousMachinations_ReportedDrakkensonToHex")

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to start Mysterious Machinations.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_Start"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You talked to Hex about the mysterious Drakkenson.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_Start"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to find the ruins near the Leafy Lake.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_FindRuinsNearLeafyLake"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You found the ruins near the Leafy Lake.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_FindRuinsNearLeafyLake"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to pull the mysterious ruins into existence.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_PulledRuinsIntoExistence"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You pulled the mysterious ruins into existence using the primordial temporal ruin.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_PulledRuinsIntoExistence"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to configure the ancient light matrix.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_ConfiguredAncientLightMatrix"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "After much sweat and tears, you configured the ancient light matrix.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_ConfiguredAncientLightMatrix"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to speak to Hex to discover what next to do.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_TalkToHex1"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You spoke to Hex and discovered you need to bring Emily with you to the ruins.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_TalkToHex1"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to clean the antenna.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_CleanAntenna"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You cleaned the antenna.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_CleanAntenna"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to figure out how to enter the portal safely.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_TalkToHex2"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Hex gave you a hazmat suit and supplies to enter the portal.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_TalkToHex2"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to find the Eldritch ruins on Azathoth.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_FoundEldritchRuins"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You found the Eldritch ruins in Azathoth.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_FoundEldritchRuins"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to craft an azathothian spacial rune",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_CraftAzathothianSpacialRune"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You crafted an azathothian spacial rune for Hex.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_CraftAzathothianSpacialRune"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to leave Azathoth and return to Hex.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_TalkToKvre"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You went to leave Azathoth and encountered the powerful Kvre, Czar of the Drakkenson.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_TalkToKvre"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to report your findings to Hex.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_ReportedDrakkensonToHex"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You reported your findings to Hex.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_ReportedDrakkensonToHex"
}
