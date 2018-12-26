--------------------------------------------------------------------------------
-- Resources/Game/DB/Shops/FishingStore.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Shop "Standard_FishingStore" {
	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 15
		},

		Output { 
			Resource = ItsyScape.Resource.Item "Bait",
			Count = 15
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 15
		},

		Output { 
			Resource = ItsyScape.Resource.Item "Feather",
			Count = 15
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 100
		},

		Output { 
			Resource = ItsyScape.Resource.Item "WimpyFishingRod",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 6000
		},

		Output { 
			Resource = ItsyScape.Resource.Item "FishermansHat",
			Count = 1
		}
	}
}

ItsyScape.Meta.Shop {
	ExchangeRate = 0.4,
	Currency = ItsyScape.Resource.Item "Coins",
	Resource = ItsyScape.Resource.Shop "Standard_FishingStore"
}
