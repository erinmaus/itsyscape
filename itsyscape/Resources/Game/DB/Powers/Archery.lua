--------------------------------------------------------------------------------
-- Resources/Game/DB/Powers/Archery.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Power "Shockwave" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForResource(5)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 60,
	MaxReduction = 30,
	MinLevel = 1,
	MaxLevel = 50,
	Skill = ItsyScape.Resource.Skill "Archery",
	Resource = ItsyScape.Resource.Power "Shockwave"
}

ItsyScape.Meta.ResourceName {
	Value = "Shockwave",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Shockwave"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Stuns your opponent for 5-10 seconds and deals 50%-150% damage depending on your Dexterity level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Shockwave"
}

ItsyScape.Resource.Power "DoubleTake" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForResource(5)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 40,
	MaxReduction = 20,
	MinLevel = 1,
	MaxLevel = 50,
	Skill = ItsyScape.Resource.Skill "Archery",
	Resource = ItsyScape.Resource.Power "DoubleTake"
}

ItsyScape.Meta.ResourceName {
	Value = "Double Take",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "DoubleTake"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Shoot two arrows. Should the first hit, the second will also. However, should the first miss, so will the second.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "DoubleTake"
}
