--------------------------------------------------------------------------------
-- Resources/Game/DB/Cooking/Recipes.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

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
		}
	}
}

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
		}
	}
}

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
		}
	}
}

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
		}
	}
}

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

ItsyScape.Resource.Recipe "ApplePie" {
	ItsyScape.Action.CookRecipe() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(1)
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
		}
	}
}

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

ItsyScape.Resource.Recipe "PecanPie" {
	ItsyScape.Action.CookRecipe() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(5)
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
		}
	}
}

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
		}
	}
}

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
		}
	}
}

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
