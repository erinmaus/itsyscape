--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/MiningSecondaries.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "PurpleSaltPeter" {
	ItsyScape.Action.Mine() {
		Requirement {
			Count = ItsyScape.Utility.xpForLevel(1),
			Resource = ItsyScape.Resource.Skill "Mining"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(1),
			Resource = ItsyScape.Resource.Skill "Mining"
		},

		Output {
			Count = 1,
			Resource = ItsyScape.Resource.Item "PurpleSaltPeter"
		}
	},
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Purple salt peter",
	Resource = ItsyScape.Resource.Item "PurpleSaltPeter"
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "A useful compound; can make gunpowder, salt meats, and fertilize plants!",
	Resource = ItsyScape.Resource.Item "PurpleSaltPeter"
}

ItsyScape.Meta.Item {
	Stackable = 1,
	Value = ItsyScape.Utility.valueForItem(1) / 2,
	Resource = ItsyScape.Resource.Item "PurpleSaltPeter"
}

ItsyScape.Resource.Item "BlackFlint" {
	ItsyScape.Action.Mine() {
		Requirement {
			Count = ItsyScape.Utility.xpForLevel(1),
			Resource = ItsyScape.Resource.Skill "Mining"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(1),
			Resource = ItsyScape.Resource.Skill "Mining"
		},

		Output {
			Count = 1,
			Resource = ItsyScape.Resource.Item "BlackFlint"
		}
	},
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Black flint",
	Resource = ItsyScape.Resource.Item "BlackFlint"
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "The pathway to pyromania!",
	Resource = ItsyScape.Resource.Item "BlackFlint"
}

ItsyScape.Meta.Item {
	Stackable = 1,
	Value = ItsyScape.Utility.valueForItem(1) / 2,
	Resource = ItsyScape.Resource.Item "BlackFlint"
}

ItsyScape.Resource.Item "CrumblySulfur" {
	ItsyScape.Action.Mine() {
		Requirement {
			Count = ItsyScape.Utility.xpForLevel(1),
			Resource = ItsyScape.Resource.Skill "Mining"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(1),
			Resource = ItsyScape.Resource.Skill "Mining"
		},

		Output {
			Count = 1,
			Resource = ItsyScape.Resource.Item "CrumblySulfur"
		}
	},
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Crumbling sulfur",
	Resource = ItsyScape.Resource.Item "CrumblySulfur"
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "A useful, powdery substance... but why does it have to smell so bad?!",
	Resource = ItsyScape.Resource.Item "CrumblySulfur"
}

ItsyScape.Meta.Item {
	Stackable = 1,
	Value = ItsyScape.Utility.valueForItem(1) / 2,
	Resource = ItsyScape.Resource.Item "CrumblySulfur"
}
