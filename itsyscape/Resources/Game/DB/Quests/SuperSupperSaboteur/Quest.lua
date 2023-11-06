--------------------------------------------------------------------------------
-- Resources/Game/DB/Quest/SuperSupperSaboteur/Quest.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local RecipeCard = ItsyScape.Resource.Item "SuperSupperSaboteur_SecretCarrotCakeRecipeCard" {
		ItsyScape.Action.ReadRecipe() {
			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_OldGirlsMilk",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_OldGirlsButter",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_DandelionFlour",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_GoldenEgg",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "VegetableOil",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "DarkBrownSugar",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_GoldenCarrot",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "RegalPecan",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Chef Allon's secret carrot cake recipe",
		Language = "en-US",
		Resource = RecipeCard
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "This is the secret carrot cake recipe Chef Allon prepared for Earl Reddick's birthday.",
		Language = "en-US",
		Resource = RecipeCard
	}

	ItsyScape.Meta.Item {
		Untradeable = 1,
		Unnoteable = 1,
		Resource = RecipeCard
	}
end

do
	local Milk = ItsyScape.Resource.Item "SuperSupperSaboteur_OldGirlsMilk" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_OldGirlsMilk",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Old Girl's milk",
		Language = "en-US",
		Resource = Milk
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Milk from the sweetest cow in the Realm!",
		Language = "en-US",
		Resource = Milk
	}

	ItsyScape.Meta.Ingredient {
		Item = Milk,
		Ingredient = ItsyScape.Resource.Ingredient "Milk"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(11),
		Resource = Milk
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Milk,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Milk,
		Value = ItsyScape.Utility.valueForItem(11)
	}
end

do
	local Butter = ItsyScape.Resource.Item "SuperSupperSaboteur_OldGirlsButter" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_OldGirlsButter",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Old Girl's butter",
		Language = "en-US",
		Resource = Butter
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The sweetest butter from the sweetest cow in the Realm!",
		Language = "en-US",
		Resource = Butter
	}

	ItsyScape.Meta.Ingredient {
		Item = Butter,
		Ingredient = ItsyScape.Resource.Ingredient "Butter"
	}

	ItsyScape.Meta.Ingredient {
		Item = Butter,
		Ingredient = ItsyScape.Resource.Ingredient "OilOrFat"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(11),
		Resource = Butter
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Butter,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Butter,
		Value = ItsyScape.Utility.valueForItem(11)
	}
end

do
	local GoldenEgg = ItsyScape.Resource.Item "SuperSupperSaboteur_GoldenEgg" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_GoldenEgg",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Golden egg",
		Language = "en-US",
		Resource = GoldenEgg
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "That egg won't crack if you drop it!",
		Language = "en-US",
		Resource = GoldenEgg
	}

	ItsyScape.Meta.Ingredient {
		Item = GoldenEgg,
		Ingredient = ItsyScape.Resource.Ingredient "GoldenEgg"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(10),
		Resource = GoldenEgg
	}

	ItsyScape.Meta.ItemUserdata {
		Item = GoldenEgg,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = GoldenEgg,
		Value = ItsyScape.Utility.valueForItem(10)
	}
end

do
	local GoldenCarrot = ItsyScape.Resource.Item "SuperSupperSaboteur_GoldenCarrot" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_GoldenCarrot",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Golden carrot",
		Language = "en-US",
		Resource = GoldenCarrot
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "One fine carrot, yum!",
		Language = "en-US",
		Resource = GoldenCarrot
	}

	ItsyScape.Meta.Ingredient {
		Item = GoldenCarrot,
		Ingredient = ItsyScape.Resource.Ingredient "Carrot"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(15),
		Resource = GoldenCarrot
	}

	ItsyScape.Meta.ItemUserdata {
		Item = GoldenCarrot,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = GoldenCarrot,
		Value = ItsyScape.Utility.valueForItem(15)
	}
end

do
	local Flour = ItsyScape.Resource.Item "SuperSupperSaboteur_DandelionFlour" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_DandelionFlour",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Dandelion flour",
		Language = "en-US",
		Resource = Flour
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Flour from the roots of a crazy dandelion.",
		Language = "en-US",
		Resource = Flour
	}

	ItsyScape.Meta.Ingredient {
		Item = Flour,
		Ingredient = ItsyScape.Resource.Ingredient "Flour"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(10),
		Resource = Flour
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Flour,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Flour,
		Value = ItsyScape.Utility.valueForItem(10)
	}
end

local Quest = ItsyScape.Utility.Quest
local Step = ItsyScape.Utility.QuestStep
local Branch = ItsyScape.Utility.QuestBranch
local Description = ItsyScape.Utility.QuestStepDescription

ItsyScape.Meta.ResourceName {
	Value = "Super Supper Saboteur",
	Language = "en-US",
	Resource = ItsyScape.Resource.Quest "SuperSupperSaboteur"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Chef Allon is planning to make dinner and dessert for the Earl of Rumbridge, but is in over his head.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Quest "SuperSupperSaboteur"
}

ItsyScape.Resource.Quest "SuperSupperSaboteur"

Quest "SuperSupperSaboteur" {
	constraints = {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Foraging",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForLevel(5)
		}
	},

	Step "SuperSupperSaboteur_Started",
	Step "SuperSupperSaboteur_GotRecipe",
	Step "SuperSupperSaboteur_GotYelledAtForGoldenCarrot",
	Step "SuperSupperSaboteur_GotPermissionForGoldenCarrot",
	Step "SuperSupperSaboteur_TurnedInCake",
	Step "SuperSupperSaboteur_ButlerDied",
	Step "SuperSupperSaboteur_ButlerInspected",
	Step "SuperSupperSaboteur_TalkedToLyra",
	Step "SuperSupperSaboteur_GotConfessionFromLyra",
	Branch {
		{
			Step "SuperSupperSaboteur_TurnedInLyra",
			Step "SuperSupperSaboteur_LitBirthdayCandle",
			Step "SuperSupperSaboteur_Complete"
		},

		{
			Step "SuperSupperSaboteur_AgreedToHelpLyra",
			Step "SuperSupperSaboteur_TalkedToCapnRaven",
			Step "SuperSupperSaboteur_MadeCandle",
			Step "SuperSupperSaboteur_BlamedSomeoneElse",

			Branch {
				{
					Step "SuperSupperSaboteur_BetrayedLyra",
					Branch {
						{
							Step "SuperSupperSaboteur_LitBirthdayCandle",
							Step "SuperSupperSaboteur_Complete"
						},
						{
							Step "SuperSupperSaboteur_LitKursedCandle",
							Step "SuperSupperSaboteur_Complete"
						}	
					}
				},
				{
					Step "SuperSupperSaboteur_LitBirthdayCandle",
					Step "SuperSupperSaboteur_Complete"
				},
				{
					Step "SuperSupperSaboteur_LitKursedCandle",
					Step "SuperSupperSaboteur_Complete"
				}
			}
		}
	},
	Step "SuperSupperSaboteur_Complete"
}

Description "SuperSupperSaboteur_Started" {
	before = "You need to start Super supper Saboteur by speaking to Chef Allon at the Rumbridge Castle kitchen.",
	after = "Chef Allon wants to cook a spectacular dinner for the Earl, Reddick. He enlisted your help after receiving a glowing recommendation from Advisor Grimm."
}

Description "SuperSupperSaboteur_GotRecipe" {
	before = "What are the ingredients to the recipe?",
	after = "Chef Allon gave you a super secret recipe card with the ingredients. If you lost it, go back to see him for another."
}

Description "SuperSupperSaboteur_GotYelledAtForGoldenCarrot" {
	before = "The golden carrot is probably grown by a farmer from Rumbridge farms. The farms are east of the castle, north of Leafy Lake.",
	after = "The grumpy farmer won't let you pick his prized golden carrot. Maybe speak to him?",
}

Description "SuperSupperSaboteur_GotPermissionForGoldenCarrot" {
	before = "The grumpy farmer needs to give you permission to pick his golden carrot.",
	after = "The grumpy farmer decided to let you pick the golden carrot, since it is for the Earl's birthday."
}

Description "SuperSupperSaboteur_TurnedInCake" {
	before = "Chef Allon needs to inspect your cake to make sure you followed the recipe.",
	after = "Chef Allon is pleased with your work and took in the cake."
}

Description "SuperSupperSaboteur_ButlerDied" {
	before = "The butler needs help.",
	after = "The butler died. Rest in peace."
}

Description "SuperSupperSaboteur_ButlerInspected" {
	before = "Maybe the butler's body has clues.",
	after = "After inspecting the butler's body, you found large canine bite marks."
}

Description "SuperSupperSaboteur_TalkedToLyra" {
	before = "Lyra, the witch in the Shade district of Rumbridge, has a large wolf familiar, according to Chef Allon.",
	after = "When speaking to Lyra, she seemed suspicious."
}

Description "SuperSupperSaboteur_GotConfessionFromLyra" {
	before = "Maybe Lyra is hiding something.",
	after = "Lyra had a dangerous, magical poison in her desk. Is this enough evidence to turn her in?"
}

Description "SuperSupperSaboteur_TurnedInLyra" {
	before = "Should you turn in Lyra to Chef Allon?",
	after = "You turned in Lyra to Chef Allon, who got the guards to arrest her and confine her to the dungeon."
}

Description "SuperSupperSaboteur_LitBirthdayCandle" {
	before = "Chef Allon might be a good chef, but he lacks the firemaking level to light the birthday candle.",
	after = "Chef Allon appreciated your firemaking expertise when lighting the birthday candle."
}

Description "SuperSupperSaboteur_AgreedToHelpLyra" {
	before = "Should you help Lyra assassinate Earl Reddick?",
	after = "Wow, you agreed to help Lyra assassinate Earl Reddick! Look at you."
}

Description "SuperSupperSaboteur_TalkedToCapnRaven" {
	before = "Cap'n Raven and her crew has been bragging about finding a freshly beached Yendorian whale to drunkards at the bar, but she's keeping the location a secret.",
	after = "Cap'n Raven agreed to take you to the Yendorian whale because she likes your guts, but she blindfolded you when doing so."
}

Description "SuperSupperSaboteur_MadeCandle" {
	before = "Lyra lacks the firemaking level to make a kursed birthday candle from the whale wax.",
	after = "Thanks to your firemaking prowess, you made a kursed birthday candle for Lyra."
}

Description "SuperSupperSaboteur_BlamedSomeoneElse" {
	before = "Lyra gave you some demonic contracts to summon a demon and its hellhound familiar to attempt to assassinate the Earl.",
	after = "The Rumbridge guards proved too capable and the demon and hellhound were slain. Time for Plan B!"
}

Description "SuperSupperSaboteur_BetrayedLyra" {
	before = "Lyra can still be turned in.",
	after = "Lyra was betrayed by you after turning her in despite agreeing to help!"
}

Description "SuperSupperSaboteur_LitKursedCandle" {
	before = "Chef Allon needs you to light the birthday candle. Of course, in your possession are two candles. What will you do?",
	after = "You lit the kursed candle and gave it to the Chef. The Earl was poisoned and died!"
}

Description "SuperSupperSaboteur_Complete" {
	before = "You need to complete Super Supper Saboteur.",
	after = "You completed Super Supper Saboteur. What a quest!"
}
