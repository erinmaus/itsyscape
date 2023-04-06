--------------------------------------------------------------------------------
-- Resources/Game/DB/Prayers/Murmurs.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Effect "MetalSkin" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(1)
		}
	}
}

ItsyScape.Meta.Prayer {
	Drain = 4,
	Style = "All",
	Resource = ItsyScape.Resource.Effect "MetalSkin"
}

ItsyScape.Meta.ResourceName {
	Value = "Metal Skin",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "MetalSkin"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Boosts melee defenses by 10%-50%, based on Faith level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "MetalSkin"
}

ItsyScape.Resource.Effect "IronWill" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(1)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Iron Will",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "IronWill"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Boosts magic defenses by 10%-50%, based on Faith level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "IronWill"
}

ItsyScape.Meta.Prayer {
	Drain = 4,
	Style = "All",
	Resource = ItsyScape.Resource.Effect "IronWill"
}

ItsyScape.Resource.Effect "TimeErosion" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(1)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Time Erosion",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "TimeErosion"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Boosts ranged defenses by 10%-50%, based on Faith level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "TimeErosion"
}

ItsyScape.Meta.Prayer {
	Drain = 4,
	Style = "All",
	Resource = ItsyScape.Resource.Effect "TimeErosion"
}

ItsyScape.Resource.Effect "WayOfTheWarrior" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(5)
		}
	}
}

ItsyScape.Meta.Prayer {
	Drain = 6,
	Style = "Attack",
	Resource = ItsyScape.Resource.Effect "WayOfTheWarrior"
}

ItsyScape.Meta.ResourceName {
	Value = "Way of the Warrior",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "WayOfTheWarrior"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Boosts melee offense by 10%.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "WayOfTheWarrior"
}

ItsyScape.Resource.Effect "PathOfLight" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(5)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Path of Light",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "PathOfLight"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Boosts magic offense by 10%.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "PathOfLight"
}

ItsyScape.Meta.Prayer {
	Drain = 6,
	Style = "Magic",
	Resource = ItsyScape.Resource.Effect "PathOfLight"
}

ItsyScape.Resource.Effect "HawksEye" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(5)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Hawk's Eye",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "HawksEye"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Boosts ranged offense by 10%.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "HawksEye"
}

ItsyScape.Meta.Prayer {
	Drain = 6,
	Style = "Archery",
	Resource = ItsyScape.Resource.Effect "HawksEye"
}

ItsyScape.Resource.Effect "GammonsReckoning" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(10)
		}
	}
}

ItsyScape.Meta.Prayer {
	Drain = 12,
	Style = "Attack",
	Resource = ItsyScape.Resource.Effect "GammonsReckoning"
}

ItsyScape.Meta.ResourceName {
	Value = "Gammon's Reckoning",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "GammonsReckoning"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Boost your minimum melee damage by 10% of your Faith level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "GammonsReckoning"
}

ItsyScape.Resource.Effect "PrisiumsWisdom" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(10)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Prisium's Wisdom",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "PrisiumsWisdom"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Boosts your minimum magic damage by 10% of your Faith level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "PrisiumsWisdom"
}

ItsyScape.Meta.Prayer {
	Drain = 12,
	Style = "Magic",
	Resource = ItsyScape.Resource.Effect "PrisiumsWisdom"
}

ItsyScape.Resource.Effect "BastielsGaze" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(10)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Bastiel's Gaze",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "BastielsGaze"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Boosts your minimum ranged damage by 10% of your Faith level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "BastielsGaze"
}

ItsyScape.Meta.Prayer {
	Drain = 12,
	Style = "Archery",
	Resource = ItsyScape.Resource.Effect "BastielsGaze"
}

ItsyScape.Resource.Effect "SwiftDagger" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(20)
		}
	}
}

ItsyScape.Meta.Prayer {
	Drain = 20,
	Style = "Attack",
	Resource = ItsyScape.Resource.Effect "SwiftDagger"
}

ItsyScape.Meta.ResourceName {
	Value = "Swift Dagger",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "SwiftDagger"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Boosts melee weapon speed by 10% to 20%, based on Faith level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "SwiftDagger"
}

ItsyScape.Resource.Effect "SharpMind" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(20)
		}
	}
}

ItsyScape.Meta.Prayer {
	Drain = 20,
	Style = "Magic",
	Resource = ItsyScape.Resource.Effect "SharpMind"
}

ItsyScape.Meta.ResourceName {
	Value = "Sharp Mind",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "SharpMind"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Boosts magic weapon speed by 10% to 20%, based on Faith level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "SharpMind"
}

ItsyScape.Resource.Effect "StableHand" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(20)
		}
	}
}

ItsyScape.Meta.Prayer {
	Drain = 20,
	Style = "Archery",
	Resource = ItsyScape.Resource.Effect "StableHand"
}

ItsyScape.Meta.ResourceName {
	Value = "Stable Hand",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "StableHand"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Boosts archery weapon speed by 10% to 20%, based on faith level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "StableHand"
}
