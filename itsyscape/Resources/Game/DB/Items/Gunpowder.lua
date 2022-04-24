--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Gunpowder.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Gunpowder = ItsyScape.Resource.Item "Gunpowder"

	local MixAction = ItsyScape.Action.Mix() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Engineering",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Charcoal",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "PurpleSaltPeter",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "CrumblySulfur",
			Count = 1
		},

		Output {
			Resource = Gunpowder,
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Engineering",
			Count = ItsyScape.Utility.xpForResource(11) * 3
		}
	}

	Gunpowder { MixAction }

	ItsyScape.Meta.DynamicSkillMultiplier {
		BaseMultiplier = 5,
		MaxMultiplier = 50,
		MinLevel = 10,
		MaxLevel = 50,
		Skill = ItsyScape.Resource.Skill "Engineering",
		Action = MixAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Chemical",
		Value = "Gunpowder",
		Resource = Gunpowder
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(11) / 5,
		Resource = Gunpowder
	}

	ItsyScape.Meta.ResourceName {
		Value = "Gunpowder",
		Language = "en-US",
		Resource = Gunpowder

	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Keep away from fire!",
		Language = "en-US",
		Resource = Gunpowder
	}
end

do
	local Dynamite = ItsyScape.Resource.Item "Dynamite"

	local MixAction = ItsyScape.Action.Mix() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Engineering",
			Count = ItsyScape.Utility.xpForLevel(15)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Charcoal",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "PurpleSaltPeter",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "CrumblySulfur",
			Count = 1
		},

		Output {
			Resource = Dynamite,
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Engineering",
			Count = ItsyScape.Utility.xpForResource(15) * 3
		}
	}

	Dynamite { MixAction }

	ItsyScape.Meta.DynamicSkillMultiplier {
		BaseMultiplier = 5,
		MaxMultiplier = 10,
		MinLevel = 15,
		MaxLevel = 55,
		Skill = ItsyScape.Resource.Skill "Engineering",
		Action = MixAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Chemical",
		Value = "Gunpowder",
		Resource = Dynamite
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(16) / 5,
		Weight = 0,
		Stackable = 1,
		Resource = Dynamite
	}

	ItsyScape.Meta.ResourceName {
		Value = "Dynamite",
		Language = "en-US",
		Resource = Dynamite
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "BOOM!",
		Language = "en-US",
		Resource = Dynamite
	}
end
