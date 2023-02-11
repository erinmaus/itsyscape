--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Veggies.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Recipe "PieCrust" {
	ItsyScape.Action.CookRecipe() {
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
		}
	}
}

ItsyScape.Resource.Recipe "SweetPieCrust" {
	ItsyScape.Action.CookRecipe() {
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
		}
	}
}

ItsyScape.Resource.Recipe "RichPieCrust" {
	ItsyScape.Action.CookRecipe() {
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
		}
	}
}

ItsyScape.Resource.Recipe "ChocolatePieCrust" {
	ItsyScape.Action.CookRecipe() {
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
		}
	}
}
