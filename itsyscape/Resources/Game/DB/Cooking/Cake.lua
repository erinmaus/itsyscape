--------------------------------------------------------------------------------
-- Resources/Game/DB/Cooking/Recipes.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Pie = ItsyScape.Resource.Ingredient "Pie"

	ItsyScape.Meta.ResourceName {
		Value = "Pie",
		Language = "en-US",
		Resource = Pie
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "You can make all kinds of pies using the cooking skill.",
		Language = "en-US",
		Resource = Pie
	}
end

do
	local PieCrust = ItsyScape.Resource.Ingredient "PieCrust"

	ItsyScape.Meta.ResourceName {
		Value = "Pie crust",
		Language = "en-US",
		Resource = PieCrust
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "You can make all kinds of pie crusts using the cooking skill.",
		Language = "en-US",
		Resource = PieCrust
	}
end

ItsyScape.Resource.Recipe "CarrotCake" {
	ItsyScape.Action.CookRecipe() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Milk",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Butter",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Flour",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Egg",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Oil",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Sugar",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Carrot",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Pecan",
			Count = 1
		}
	}
}