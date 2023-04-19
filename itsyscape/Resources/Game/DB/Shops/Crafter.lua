--------------------------------------------------------------------------------
-- Resources/Game/DB/Shops/Crafter.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Shop "Standard_Crafter" {
	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 5
		},

		Output { 
			Resource = ItsyScape.Resource.Item "Needle",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 1
		},

		Output { 
			Resource = ItsyScape.Resource.Item "PlainThread",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = ItsyScape.Utility.valueForItem(5)
		},

		Output { 
			Resource = ItsyScape.Resource.Item "MooishLeatherHide",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = ItsyScape.Utility.valueForItem(6)
		},

		Output { 
			Resource = ItsyScape.Resource.Item "RedDye",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = ItsyScape.Utility.valueForItem(6)
		},

		Output { 
			Resource = ItsyScape.Resource.Item "OrangeDye",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = ItsyScape.Utility.valueForItem(6)
		},

		Output { 
			Resource = ItsyScape.Resource.Item "YellowDye",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = ItsyScape.Utility.valueForItem(6)
		},

		Output { 
			Resource = ItsyScape.Resource.Item "GreenDye",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = ItsyScape.Utility.valueForItem(6)
		},

		Output { 
			Resource = ItsyScape.Resource.Item "BlueDye",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = ItsyScape.Utility.valueForItem(6)
		},

		Output { 
			Resource = ItsyScape.Resource.Item "PurpleDye",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = ItsyScape.Utility.valueForItem(6)
		},

		Output { 
			Resource = ItsyScape.Resource.Item "BrownDye",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = ItsyScape.Utility.valueForItem(6)
		},

		Output { 
			Resource = ItsyScape.Resource.Item "WhiteDye",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = ItsyScape.Utility.valueForItem(6)
		},

		Output { 
			Resource = ItsyScape.Resource.Item "BlackDye",
			Count = 1
		}
	}
}

ItsyScape.Meta.Shop {
	ExchangeRate = 0.27,
	Currency = ItsyScape.Resource.Item "Coins",
	Resource = ItsyScape.Resource.Shop "Standard_Crafter"
}
