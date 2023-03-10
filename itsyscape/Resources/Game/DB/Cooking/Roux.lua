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
			Resource = ItsyScape.Resource.Ingredient "Oil",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Salt",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Seasoning",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "Roux",
			Count = 1
		}
	}
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
			Resource = ItsyScape.Resource.Ingredient "Oil",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Salt",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Seasoning",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "WellCookedRoux",
			Count = 1
		}
	}
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
