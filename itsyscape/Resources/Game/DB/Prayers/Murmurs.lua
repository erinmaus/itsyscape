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
	Resource = ItsyScape.Resource.Effect "HawksEye"
}
