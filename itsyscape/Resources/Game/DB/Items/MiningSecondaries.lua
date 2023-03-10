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
	ItsyScape.Action.ObtainSecondary() {
		Requirement {
			Count = ItsyScape.Utility.xpForLevel(5),
			Resource = ItsyScape.Resource.Skill "Mining"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(5),
			Resource = ItsyScape.Resource.Skill "Mining"
		},

		Output {
			Count = 1,
			Resource = ItsyScape.Resource.Item "PurpleSaltPeter"
		}
	},

	ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(15)
		},

		Input {
			Resource = ItsyScape.Resource.Item "PurpleSaltPeter",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(16)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Purple salt peter",
	Resource = ItsyScape.Resource.Item "PurpleSaltPeter"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "A useful compound; can make gunpowder, salt meats, and fertilize plants!",
	Resource = ItsyScape.Resource.Item "PurpleSaltPeter"
}

ItsyScape.Meta.Item {
	Stackable = 1,
	Value = ItsyScape.Utility.valueForItem(5),
	Resource = ItsyScape.Resource.Item "PurpleSaltPeter"
}

ItsyScape.Meta.SecondaryWeight {
	Weight = 500,
	Resource = ItsyScape.Resource.Item "PurpleSaltPeter"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "PurpleSaltPeter",
	Ingredient = ItsyScape.Resource.Ingredient "Salt"
}

ItsyScape.Resource.Item "BlackFlint" {
	ItsyScape.Action.ObtainSecondary() {
		Requirement {
			Count = ItsyScape.Utility.xpForLevel(5),
			Resource = ItsyScape.Resource.Skill "Mining"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(5),
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

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "The pathway to pyromania!",
	Resource = ItsyScape.Resource.Item "BlackFlint"
}

ItsyScape.Meta.Item {
	Stackable = 1,
	Value = ItsyScape.Utility.valueForItem(5),
	Resource = ItsyScape.Resource.Item "BlackFlint"
}

ItsyScape.Meta.SecondaryWeight {
	Weight = 100,
	Resource = ItsyScape.Resource.Item "BlackFlint"
}

ItsyScape.Resource.Item "CrumblySulfur" {
	ItsyScape.Action.ObtainSecondary() {
		Requirement {
			Count = ItsyScape.Utility.xpForLevel(5),
			Resource = ItsyScape.Resource.Skill "Mining"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(5),
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

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "A useful, powdery substance... but why does it have to smell so bad?!",
	Resource = ItsyScape.Resource.Item "CrumblySulfur"
}

ItsyScape.Meta.Item {
	Stackable = 1,
	Value = ItsyScape.Utility.valueForItem(5),
	Resource = ItsyScape.Resource.Item "CrumblySulfur"
}

ItsyScape.Meta.SecondaryWeight {
	Weight = 500,
	Resource = ItsyScape.Resource.Item "CrumblySulfur"
}
