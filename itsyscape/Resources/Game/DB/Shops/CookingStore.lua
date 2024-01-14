--------------------------------------------------------------------------------
-- Resources/Game/DB/Shops/CookingStore.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Shop "Special_CookingStore_Allon" {
	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 100
		},

		Output {
			Resource = ItsyScape.Resource.Item "AllPurposeFlour",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 100
		},

		Output {
			Resource = ItsyScape.Resource.Item "Sugar",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 250
		},

		Output {
			Resource = ItsyScape.Resource.Item "Chocolate",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 100
		},

		Output {
			Resource = ItsyScape.Resource.Item "VegetableOil",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 100
		},

		Output {
			Resource = ItsyScape.Resource.Item "Egg",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 100
		},

		Output {
			Resource = ItsyScape.Resource.Item "Milk",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 100
		},

		Output {
			Resource = ItsyScape.Resource.Item "Butter",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 100
		},

		Output {
			Resource = ItsyScape.Resource.Item "TableSalt",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 2000
		},

		Output {
			Resource = ItsyScape.Resource.Item "FineSageSalt",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 2000
		},

		Output {
			Resource = ItsyScape.Resource.Item "FineDexterousSalt",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 2000
		},

		Output {
			Resource = ItsyScape.Resource.Item "FineKosherSalt",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 2000
		},

		Output {
			Resource = ItsyScape.Resource.Item "FineWarriorSalt",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 2000
		},

		Output {
			Resource = ItsyScape.Resource.Item "FineToughSalt",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 2000
		},

		Output {
			Resource = ItsyScape.Resource.Item "FineArtisanSalt",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 2000
		},

		Output {
			Resource = ItsyScape.Resource.Item "FineGathererSalt",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 2000
		},

		Output {
			Resource = ItsyScape.Resource.Item "FineAdventurerSalt",
			Count = 1
		}
	}
}

ItsyScape.Meta.Shop {
	ExchangeRate = 0.3,
	Currency = ItsyScape.Resource.Item "Coins",
	Resource = ItsyScape.Resource.Shop "Special_CookingStore_Allon"
}
