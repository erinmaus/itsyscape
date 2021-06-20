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
			Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_ReportedCreepyDollToHex",
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
	"MysteriousMachinations_FoundTesseract")

ItsyScape.Utility.questStep(
	"MysteriousMachinations_FoundTesseract",
	"MysteriousMachinations_TalkToCreepyDoll")

ItsyScape.Utility.questStep(
	"MysteriousMachinations_TalkToCreepyDoll",
	"MysteriousMachinations_ReportedCreepyDollToHex")

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to start Mysterious Machinations.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_Start"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You talked to Hex about Old One's tech.",
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
	Value = "You need to power on the mysterious ruins.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_PulledRuinsIntoExistence"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You powered on the mysterious ruins using the battery and button.",
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
	Value = "You need to find the Tesseract in the ruins.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_FoundTesseract"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You found the Tesseract.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_FoundTesseract"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to leave Azathoth and return the Tesseract to Hex.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_TalkToCreepyDoll"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You went to leave Azathoth and encountered a creepy doll.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_TalkToCreepyDoll"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to report your findings to Hex.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_ReportedCreepyDollToHex"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You reported your findings to Hex.",
	Resource = ItsyScape.Resource.KeyItem "MysteriousMachinations_ReportedCreepyDollToHex"
}

ItsyScape.Resource.Item "MysteriousMachinations_PowerButton" {
	-- Nothing.
}

ItsyScape.Meta.Item {
	Untradeable = 1,
	Resource = ItsyScape.Resource.Item "MysteriousMachinations_PowerButton"
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Power button",
	Resource = ItsyScape.Resource.Item "MysteriousMachinations_PowerButton"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Activates ancient ruins or your money back!",
	Resource = ItsyScape.Resource.Item "MysteriousMachinations_PowerButton"
}

ItsyScape.Resource.Item "MysteriousMachinations_Battery" {
	-- Nothing.
}

ItsyScape.Meta.Item {
	Untradeable = 1,
	Resource = ItsyScape.Resource.Item "MysteriousMachinations_Battery"
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Hex Labs, Inc. double-A battery",
	Resource = ItsyScape.Resource.Item "MysteriousMachinations_Battery"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "A magical battery compatible with Old One's tech.",
	Resource = ItsyScape.Resource.Item "MysteriousMachinations_Battery"
}

ItsyScape.Resource.Prop "MysteriousMachinations_MysteriousRuins_Pillar" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BlockingProp",
	Resource = ItsyScape.Resource.Prop "MysteriousMachinations_MysteriousRuins_Pillar"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 5,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "MysteriousMachinations_MysteriousRuins_Pillar"
}

ItsyScape.Meta.ResourceName {
	Value = "Mysterious ruins pillar",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "MysteriousMachinations_MysteriousRuins_Pillar"
}

ItsyScape.Meta.ResourceDescription {
	Value = "What purpose does this pillar serve?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "MysteriousMachinations_MysteriousRuins_Pillar"
}

ItsyScape.Resource.Prop "MysteriousMachinations_MysteriousRuins_Hypersphere" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BlockingProp",
	Resource = ItsyScape.Resource.Prop "MysteriousMachinations_MysteriousRuins_Hypersphere"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 2,
	SizeZ = 3.5,
	MapObject = ItsyScape.Resource.Prop "MysteriousMachinations_MysteriousRuins_Hypersphere"
}

ItsyScape.Meta.ResourceName {
	Value = "Mysterious ruins hypersphere",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "MysteriousMachinations_MysteriousRuins_Hypersphere"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A shadow of a sphere from a higher dimension...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "MysteriousMachinations_MysteriousRuins_Hypersphere"
}

ItsyScape.Resource.Prop "MysteriousMachinations_MysteriousRuins_AncientMatrix" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "MysteriousMachinations_MysteriousRuins_AncientMatrix"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 1.5,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "MysteriousMachinations_MysteriousRuins_AncientMatrix"
}

ItsyScape.Meta.ResourceName {
	Value = "Mysterious ruins matrix",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "MysteriousMachinations_MysteriousRuins_AncientMatrix"
}

ItsyScape.Meta.ResourceDescription {
	Value = "It's an ancient matrix...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "MysteriousMachinations_MysteriousRuins_AncientMatrix"
}

ItsyScape.Resource.Prop "MysteriousMachinations_MysteriousRuins_Antenna" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BlockingProp",
	Resource = ItsyScape.Resource.Prop "MysteriousMachinations_MysteriousRuins_Antenna"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 6,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "MysteriousMachinations_MysteriousRuins_Antenna"
}

ItsyScape.Meta.ResourceName {
	Value = "Mysterious ruins antenna",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "MysteriousMachinations_MysteriousRuins_Antenna"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Feels like it's listening and watching...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "MysteriousMachinations_MysteriousRuins_Antenna"
}
