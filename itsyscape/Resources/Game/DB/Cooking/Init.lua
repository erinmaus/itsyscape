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
