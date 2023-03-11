--------------------------------------------------------------------------------
-- Resources/Game/DB/Cooking/Init.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ResourceType "Recipe"
ResourceType "Ingredient"

ActionType "CookRecipe"
ActionType "CookIngredient"
ActionType "OpenCookingWindow"

Meta "Ingredient" {
	Item = Meta.TYPE_RESOURCE,
	Ingredient = Meta.TYPE_RESOURCE
}

ItsyScape.Resource.KeyItem "Message_Cooking_RecipeNotReady" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Recipe error",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "Message_Cooking_RecipeNotReady"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The recipe is missing ingredients!",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "Message_Cooking_RecipeNotReady"
}

ItsyScape.Resource.KeyItem "Message_Cooking_IngredientNotInRecipe" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Ingredient error",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "Message_Cooking_IngredientNotInRecipe"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The ingredient does not belong in the recipe or you do not have the skill to cook it yet.",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "Message_Cooking_IngredientNotInRecipe"
}

ItsyScape.Resource.KeyItem "Message_Cooking_TooManyIngredients" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Ingredient error",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "Message_Cooking_TooManyIngredients"
}

ItsyScape.Meta.ResourceDescription {
	Value = "There would be too many of this ingredient in the recipe!",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "Message_Cooking_TooManyIngredients"
}

do
	ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"

	ItsyScape.Meta.ResourceName {
		Value = "Item healing",
		Language = "en-US",
		Resource = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Restores hitpoints by consuming an item.",
		Language = "en-US",
		Resource = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Heals %d hitpoint(s).",
		Language = "en-US",
		Resource = ItsyScape.Resource.KeyItem "Message_ItemHealingUserdata_Description"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Greedily heals %d hitpoint(s).",
		Language = "en-US",
		Resource = ItsyScape.Resource.KeyItem "Message_ItemHealingUserdata_ZealousDescription"
	}

	Meta "ItemHealingUserdata" {
		Hitpoints = Meta.TYPE_INTEGER,
		IsZealous = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}
end

do
	ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"

	ItsyScape.Meta.ResourceName {
		Value = "Item stat boosting",
		Language = "en-US",
		Resource = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Boosts or lowers stats by consuming an item.",
		Language = "en-US",
		Resource = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Raises %s by %d level(s).",
		Language = "en-US",
		Resource = ItsyScape.Resource.KeyItem "Message_ItemStatBoostUserdata_Buff"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Lowers %s by %d level(s).",
		Language = "en-US",
		Resource = ItsyScape.Resource.KeyItem "Message_ItemStatBoostUserdata_Debuff"
	}

	Meta "ItemStatBoostUserdata" {
		Skill = Meta.TYPE_RESOURCE,
		Boost = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}
end

do
	ItsyScape.Resource.ItemUserdata "ItemValueUserdata"

	ItsyScape.Meta.ResourceName {
		Value = "Item value",
		Language = "en-US",
		Resource = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Defines the worth an item.",
		Language = "en-US",
		Resource = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Worth %s coin(s).",
		Language = "en-US",
		Resource = ItsyScape.Resource.KeyItem "Message_ItemValueUserdata_Description"
	}

	Meta "ItemValueUserdata" {
		Value = Meta.TYPE_REAL,
		Resource = Meta.TYPE_RESOURCE
	}
end

do
	ItsyScape.Resource.ItemUserdata "ItemIngredientsUserdata"

	ItsyScape.Meta.ResourceName {
		Value = "Item ingredients",
		Language = "en-US",
		Resource = ItsyScape.Resource.ItemUserdata "ItemIngredientsUserdata"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Lists the ingredients in food.",
		Language = "en-US",
		Resource = ItsyScape.Resource.ItemUserdata "ItemIngredientsUserdata"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Ingredients: %s",
		Language = "en-US",
		Resource = ItsyScape.Resource.KeyItem "Message_ItemIngredientsUserdata_Prefix"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "%s",
		Language = "en-US",
		Resource = ItsyScape.Resource.KeyItem "Message_ItemIngredientsUserdata_Single"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "%dx %s",
		Language = "en-US",
		Resource = ItsyScape.Resource.KeyItem "Message_ItemIngredientsUserdata_Multiple"
	}
end
