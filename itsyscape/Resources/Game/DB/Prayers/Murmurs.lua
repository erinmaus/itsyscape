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
	Value = "Boosts defense roll by 10% to 50%, based on Faith level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "MetalSkin"
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
	Drain = 12,
	Style = "All",
	Resource = ItsyScape.Resource.Effect "WayOfTheWarrior"
}

ItsyScape.Meta.ResourceName {
	Value = "Way of the Warrior",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "WayOfTheWarrior"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Boosts offense by 10%.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "WayOfTheWarrior"
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
	Drain = 14,
	Style = "All",
	Resource = ItsyScape.Resource.Effect "GammonsReckoning"
}

ItsyScape.Meta.ResourceName {
	Value = "Gammon's Reckoning",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "GammonsReckoning"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Boost your minimum damage by 10% of your max hit.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "GammonsReckoning"
}

ItsyScape.Resource.Effect "TimeErosion" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(15)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Time Erosion",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "TimeErosion"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Slows enemy's attack speed by 10%.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "TimeErosion"
}

ItsyScape.Meta.Prayer {
	Drain = 6,
	Style = "All",
	Resource = ItsyScape.Resource.Effect "TimeErosion"
}

ItsyScape.Resource.Effect "IronWill" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(20)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Iron Will",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "IronWill"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Increases accuracy and damage by 20% to 30% based on Faith level, but reduces defenses by 50%.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "IronWill"
}

ItsyScape.Meta.Prayer {
	Drain = 20,
	Style = "All",
	Resource = ItsyScape.Resource.Effect "IronWill"
}

ItsyScape.Resource.Effect "HawksEye" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(25)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Hawk's Eye",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "HawksEye"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Boosts weapon range by one-and-a-half tiles.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "HawksEye"
}

ItsyScape.Meta.Prayer {
	Drain = 8,
	Style = "All",
	Resource = ItsyScape.Resource.Effect "HawksEye"
}

ItsyScape.Resource.Effect "BastielsGaze" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(30)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Bastiel's Gaze",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "BastielsGaze"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Increases attack speed by 10 to 20%, based on your Faith level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "BastielsGaze"
}

ItsyScape.Meta.Prayer {
	Drain = 14,
	Style = "All",
	Resource = ItsyScape.Resource.Effect "BastielsGaze"
}

ItsyScape.Resource.Effect "PathOfLight" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(35)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Path of Light",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "PathOfLight"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Restores prayer points by 5% to 10% of damage dealt, based on Faith level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "PathOfLight"
}

ItsyScape.Meta.Prayer {
	Drain = 15,
	Style = "All",
	Resource = ItsyScape.Resource.Effect "PathOfLight"
}


ItsyScape.Resource.Effect "PrisiumsWisdom" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(40)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Prisium's Wisdom",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "PrisiumsWisdom"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Drains 5% to 10% of damage dealt from opponent's prayer points, based on Faith level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "PrisiumsWisdom"
}

ItsyScape.Meta.Prayer {
	Drain = 20,
	Style = "All",
	Resource = ItsyScape.Resource.Effect "PrisiumsWisdom"
}

ItsyScape.Resource.Effect "GammonsGrace" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(45)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Gammon's Grace",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "GammonsGrace"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Reduces melee damage received by 25% to 50%, based on Faith level",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "GammonsGrace"
}

ItsyScape.Meta.Prayer {
	Drain = 50,
	Style = "All",
	Resource = ItsyScape.Resource.Effect "GammonsGrace"
}

ItsyScape.Resource.Effect "PrisiumsProtection" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(45)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Prisium's Protection",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "PrisiumsProtection"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Reduces magic damage received by 25% to 50%, based on Faith level",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "PrisiumsProtection"
}

ItsyScape.Meta.Prayer {
	Drain = 50,
	Style = "All",
	Resource = ItsyScape.Resource.Effect "PrisiumsProtection"
}

ItsyScape.Resource.Effect "BastielsBarricade" {
	ItsyScape.Action.Pray() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(45)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Bastiel's Barricade",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "BastielsBarricade"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Reduces archery damage received by 25% to 50%, based on Faith level",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "BastielsBarricade"
}

ItsyScape.Meta.Prayer {
	Drain = 50,
	Style = "All",
	Resource = ItsyScape.Resource.Effect "BastielsBarricade"
}
