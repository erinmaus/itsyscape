--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Veggies.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "YellowOnion" {
	ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(5)
		},

		Input {
			Resource = ItsyScape.Resource.Item "YellowOnion",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(6)
		}
	}
}

ItsyScape.Meta.ResourceCategory {
	Key = "Cooking",
	Value = "Veggies",
	Resource = ItsyScape.Resource.Item "YellowOnion"
}

ItsyScape.Meta.ResourceName {
	Value = "Yellow onion",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "YellowOnion"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Good for cooking.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "YellowOnion"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(6),
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "YellowOnion"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "YellowOnion",
	Ingredient = ItsyScape.Resource.Ingredient "Onion"
}

ItsyScape.Resource.Item "Celery" {
	ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(5)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Celery",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(6)
		}
	}
}

ItsyScape.Meta.ResourceCategory {
	Key = "Cooking",
	Value = "Veggies",
	Resource = ItsyScape.Resource.Item "Celery"
}

ItsyScape.Meta.ResourceName {
	Value = "Celery",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Celery"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Good for cooking.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Celery"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(6),
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "Celery"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "Celery",
	Ingredient = ItsyScape.Resource.Ingredient "Celery"
}

ItsyScape.Resource.Item "Carrot" {
	ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(5)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Carrot",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(6)
		}
	}
}

ItsyScape.Meta.ResourceCategory {
	Key = "Cooking",
	Value = "Veggies",
	Resource = ItsyScape.Resource.Item "Carrot"
}

ItsyScape.Meta.ResourceName {
	Value = "Carrot",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Carrot"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Good for cooking.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Carrot"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(6),
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "Carrot"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "Carrot",
	Ingredient = ItsyScape.Resource.Ingredient "Carrot"
}

ItsyScape.Resource.Item "GreenPepper" {
	ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(5)
		},

		Input {
			Resource = ItsyScape.Resource.Item "GreenPepper",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(6)
		}
	}
}

ItsyScape.Meta.ResourceCategory {
	Key = "Cooking",
	Value = "Veggies",
	Resource = ItsyScape.Resource.Item "GreenPepper"
}

ItsyScape.Meta.ResourceName {
	Value = "Green pepper",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GreenPepper"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Good for cooking.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GreenPepper"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(6),
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "GreenPepper"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "GreenPepper",
	Ingredient = ItsyScape.Resource.Ingredient "BellPepper"
}

ItsyScape.Resource.Item "GreenOnion" {
	ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Green",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(2)
		}
	}
}

ItsyScape.Meta.ResourceCategory {
	Key = "Cooking",
	Value = "Veggies",
	Resource = ItsyScape.Resource.Item "GreenOnion"
}

ItsyScape.Meta.ResourceName {
	Value = "Green onion",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GreenOnion"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Good for cooking.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GreenOnion"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(2),
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "GreenOnion"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "GreenOnion",
	Ingredient = ItsyScape.Resource.Ingredient "Onion"
}
