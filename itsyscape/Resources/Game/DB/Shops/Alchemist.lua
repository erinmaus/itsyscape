--------------------------------------------------------------------------------
-- Resources/Game/DB/Shops/Alchemist.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Shop "Standard_Alchemist" {
	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = ItsyScape.Utility.valueForItem(2)
		},

		Output { 
			Resource = ItsyScape.Resource.Item "UnfocusedRune",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = ItsyScape.Utility.valueForItem(3)
		},

		Output { 
			Resource = ItsyScape.Resource.Item "AirRune",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = ItsyScape.Utility.valueForItem(4)
		},

		Output { 
			Resource = ItsyScape.Resource.Item "EarthRune",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = ItsyScape.Utility.valueForItem(5)
		},

		Output { 
			Resource = ItsyScape.Resource.Item "WaterRune",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = ItsyScape.Utility.valueForItem(11)
		},

		Output { 
			Resource = ItsyScape.Resource.Item "FireRune",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = ItsyScape.Utility.valueForItem(21)
		},

		Output { 
			Resource = ItsyScape.Resource.Item "CosmicRune",
			Count = 1
		}
	}
}

ItsyScape.Meta.Shop {
	ExchangeRate = 0.3,
	Currency = ItsyScape.Resource.Item "Coins",
	Resource = ItsyScape.Resource.Shop "Standard_Alchemist"
}
