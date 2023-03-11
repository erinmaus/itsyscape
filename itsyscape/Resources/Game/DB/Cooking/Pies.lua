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

ItsyScape.Resource.Recipe "PieCrust" {
	ItsyScape.Action.CookRecipe() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(5)
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Flour",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Butter",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Salt",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "PieCrust",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(6)
		}
	}
}

do
	local CookAction = ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(5)
		},

		Input {
			Resource = ItsyScape.Resource.Item "PieCrust",
			Count = 1,
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(6)
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = CookAction
	}

	ItsyScape.Resource.Item "PieCrust" {
		CookAction
	}
end

ItsyScape.Meta.ResourceName {
	Value = "Pie crust",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "PieCrust"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A simple pie crust.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "PieCrust"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "PieCrust",
	Ingredient = ItsyScape.Resource.Ingredient "PieCrust"
}

ItsyScape.Resource.Recipe "SweetPieCrust" {
	ItsyScape.Action.CookRecipe() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(7)
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Flour",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Butter",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Sugar",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Salt",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "SweetPieCrust",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(8)
		}
	}
}

do
	local CookAction = ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(7)
		},

		Input {
			Resource = ItsyScape.Resource.Item "SweetPieCrust",
			Count = 1,
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(8)
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = CookAction
	}

	ItsyScape.Resource.Item "SweetPieCrust" {
		CookAction
	}
end

ItsyScape.Meta.ResourceName {
	Value = "Sweet pie crust",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "SweetPieCrust"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A sweet pie crust, can make a good fruit pie with this!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "SweetPieCrust"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "SweetPieCrust",
	Ingredient = ItsyScape.Resource.Ingredient "PieCrust"
}

ItsyScape.Resource.Recipe "RichPieCrust" {
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
			Resource = ItsyScape.Resource.Ingredient "Butter",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Sugar",
			Count = 2
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Salt",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "RichPieCrust",
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
			Resource = ItsyScape.Resource.Item "RichPieCrust",
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

	ItsyScape.Resource.Item "RichPieCrust" {
		CookAction
	}
end

ItsyScape.Meta.ResourceName {
	Value = "Rich pie crust",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "RichPieCrust"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Flakey and delicous!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "RichPieCrust"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "RichPieCrust",
	Ingredient = ItsyScape.Resource.Ingredient "PieCrust"
}

ItsyScape.Resource.Recipe "ChocolatePieCrust" {
	ItsyScape.Action.CookRecipe() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(15)
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Flour",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Butter",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Sugar",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Salt",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Chocolate",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "ChocolatePieCrust",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(16)
		}
	}
}

do
	local CookAction = ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(15)
		},

		Input {
			Resource = ItsyScape.Resource.Item "ChocolatePieCrust",
			Count = 1,
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(16)
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = CookAction
	}

	ItsyScape.Resource.Item "ChocolatePieCrust" {
		CookAction
	}
end

ItsyScape.Meta.ResourceName {
	Value = "Chocolate pie crust",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ChocolatePieCrust"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A gourmet pie crust.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ChocolatePieCrust"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "ChocolatePieCrust",
	Ingredient = ItsyScape.Resource.Ingredient "PieCrust"
}

ItsyScape.Resource.Recipe "ApplePie" {
	ItsyScape.Action.CookRecipe() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(6)
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "PieCrust",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Apple",
			Count = 3
		},

		Output {
			Resource = ItsyScape.Resource.Item "ApplePie",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(7)
		}
	}
}

do
	local CookAction = ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(6)
		},

		Input {
			Resource = ItsyScape.Resource.Item "ApplePie",
			Count = 1,
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(7)
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = CookAction
	}

	ItsyScape.Resource.Item "ApplePie" {
		CookAction
	}
end

ItsyScape.Meta.ResourceName {
	Value = "Apple pie",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ApplePie"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A delicious apple pie, fresh out of the oven!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ApplePie"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "ApplePie",
	Ingredient = ItsyScape.Resource.Ingredient "Pie"
}

ItsyScape.Resource.Recipe "PecanPie" {
	ItsyScape.Action.CookRecipe() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(6)
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "PieCrust",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Pecan",
			Count = 3
		},

		Output {
			Resource = ItsyScape.Resource.Item "PecanPie",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(7)
		}
	}
}

do
	local CookAction = ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(6)
		},

		Input {
			Resource = ItsyScape.Resource.Item "PecanPie",
			Count = 1,
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(7)
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = CookAction
	}

	ItsyScape.Resource.Item "PecanPie" {
		CookAction
	}
end

ItsyScape.Meta.ResourceName {
	Value = "Pecan pie",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "PecanPie"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Not good if you're allergic to nuts!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "PecanPie"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "PecanPie",
	Ingredient = ItsyScape.Resource.Ingredient "Pie"
}

ItsyScape.Resource.Recipe "FishPie" {
	ItsyScape.Action.CookRecipe() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(20)
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "PieCrust",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Fish",
			Count = 3
		},

		Output {
			Resource = ItsyScape.Resource.Item "FishPie",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(21)
		}
	}
}

do
	local CookAction = ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(20)
		},

		Input {
			Resource = ItsyScape.Resource.Item "FishPie",
			Count = 1,
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(21)
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = CookAction
	}

	ItsyScape.Resource.Item "FishPie" {
		CookAction
	}
end

ItsyScape.Meta.ResourceName {
	Value = "Fish pie",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "FishPie"
}

ItsyScape.Meta.ResourceDescription {
	Value = "This looks kind of gross...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "FishPie"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "FishPie",
	Ingredient = ItsyScape.Resource.Ingredient "Pie"
}

ItsyScape.Resource.Recipe "MeatPie" {
	ItsyScape.Action.CookRecipe() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(20)
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "PieCrust",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Meat",
			Count = 3
		},

		Output {
			Resource = ItsyScape.Resource.Item "MeatPie",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(21)
		}
	}
}

do
	local CookAction = ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(20)
		},

		Input {
			Resource = ItsyScape.Resource.Item "MeatPie",
			Count = 1,
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(21)
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = CookAction
	}

	ItsyScape.Resource.Item "MeatPie" {
		CookAction
	}
end

ItsyScape.Meta.ResourceName {
	Value = "Meat pie",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "MeatPie"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A vegetarian's worst enemy.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "MeatPie"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "MeatPie",
	Ingredient = ItsyScape.Resource.Ingredient "Pie"
}

ItsyScape.Resource.Recipe "PieFlavoredPie" {
	ItsyScape.Action.CookRecipe() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(60)
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "PieCrust",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Pie",
			Count = 2
		},

		Output {
			Resource = ItsyScape.Resource.Item "PieFlavoredPie",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(61)
		}
	}
}

do
	local CookAction = ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(60)
		},

		Input {
			Resource = ItsyScape.Resource.Item "PieFlavoredPie",
			Count = 1,
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(61)
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = CookAction
	}

	ItsyScape.Resource.Item "PieFlavoredPie" {
		CookAction
	}
end

ItsyScape.Meta.ResourceName {
	Value = "Pie-flavored pie",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "PieFlavoredPie"
}

ItsyScape.Meta.ResourceDescription {
	Value = "I baked you a pie!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "PieFlavoredPie"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "PieFlavoredPie",
	Ingredient = ItsyScape.Resource.Ingredient "Pie"
}
