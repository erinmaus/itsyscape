--------------------------------------------------------------------------------
-- Resources/Game/DB/Cooking/Gumbo.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Recipe "SeafoodGumbo" {
	ItsyScape.Action.CookRecipe() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(50)
		},

		Input {
			Resource = ItsyScape.Resource.Item "WellCookedRoux",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "GreenPepper",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "Celery",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "YellowOnion",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "GreenOnion",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Fish",
			Count = 3
		},

		Output {
			Resource = ItsyScape.Resource.Item "SeafoodGumbo",
			Count = 1
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Seafood gumbo",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "SeafoodGumbo"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A gumbo brimming with seafood. Quite filling!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "SeafoodGumbo"
}
