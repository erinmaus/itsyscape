--------------------------------------------------------------------------------
-- Resources/Game/DB/Shops/Butcher.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Shop "Standard_Butcher" {
	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = ItsyScape.Utility.valueForItem(3)
		},

		Output { 
			Resource = ItsyScape.Resource.Item "Beef",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = ItsyScape.Utility.valueForItem(3)
		},

		Output { 
			Resource = ItsyScape.Resource.Item "Pork",
			Count = 1
		}
	}
}

ItsyScape.Meta.Shop {
	ExchangeRate = 0.3,
	Currency = ItsyScape.Resource.Item "Coins",
	Resource = ItsyScape.Resource.Shop "Standard_Butcher"
}
