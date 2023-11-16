--------------------------------------------------------------------------------
-- Resources/Game/DB/Cooking/Pies.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Roux = ItsyScape.Resource.Ingredient "Roux"

	ItsyScape.Meta.ResourceName {
		Value = "Roux",
		Language = "en-US",
		Resource = Roux
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The base of many sauces, made from flour and fat.",
		Language = "en-US",
		Resource = Roux
	}
end

ItsyScape.Resource.Recipe "Roux" {
	ItsyScape.Action.CookRecipe() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Flour",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "OilOrFat",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Salt",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "Roux",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(11)
		}
	}
}

do
	local CookAction = ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Roux",
			Count = 1,
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(11)
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = CookAction
	}

	ItsyScape.Resource.Item "Roux" {
		CookAction
	}
end

ItsyScape.Meta.Item {
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "Roux"
}

ItsyScape.Meta.ResourceName {
	Value = "Roux",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Roux"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A basic roux, good for a bunch of possible dishes.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Roux"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "Roux",
	Ingredient = ItsyScape.Resource.Ingredient "Roux"
}

ItsyScape.Meta.ItemUserdata {
	Item = ItsyScape.Resource.Item "Roux",
	Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
}

ItsyScape.Meta.ItemStatBoostUserdata {
	Skill = ItsyScape.Resource.Skill "Defense",
	Boost = 3,
	Resource = ItsyScape.Resource.Item "Roux"
}

ItsyScape.Meta.ItemUserdata {
	Item = ItsyScape.Resource.Item "Roux",
	Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
}

ItsyScape.Meta.ItemHealingUserdata {
	Hitpoints = 2,
	Resource = ItsyScape.Resource.Item "Roux"
}

ItsyScape.Resource.Recipe "WellCookedRoux" {
	ItsyScape.Action.CookRecipe() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(45)
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Flour",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "OilOrFat",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "WellCookedRoux",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(46)
		}
	}
}

do
	local CookAction = ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(45)
		},

		Input {
			Resource = ItsyScape.Resource.Item "WellCookedRoux",
			Count = 1,
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(46)
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = CookAction
	}

	ItsyScape.Resource.Item "WellCookedRoux" {
		CookAction
	}
end

ItsyScape.Meta.Item {
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "WellCookedRoux"
}

ItsyScape.Meta.ResourceName {
	Value = "Well cooked roux",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "WellCookedRoux"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A well cooked roux, good for gumbo and other heavy dishes.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "WellCookedRoux"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "WellCookedRoux",
	Ingredient = ItsyScape.Resource.Ingredient "Roux"
}

ItsyScape.Meta.ItemUserdata {
	Item = ItsyScape.Resource.Item "WellCookedRoux",
	Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
}

ItsyScape.Meta.ItemStatBoostUserdata {
	Skill = ItsyScape.Resource.Skill "Defense",
	Boost = 10,
	Resource = ItsyScape.Resource.Item "WellCookedRoux"
}

ItsyScape.Meta.ItemUserdata {
	Item = ItsyScape.Resource.Item "WellCookedRoux",
	Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
}

ItsyScape.Meta.ItemHealingUserdata {
	Hitpoints = 5,
	Resource = ItsyScape.Resource.Item "WellCookedRoux"
}
