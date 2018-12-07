--------------------------------------------------------------------------------
-- Resources/Game/DB/Shops/GeneralStore.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Shop "Standard_GeneralStore" {
	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 10
		},

		Output { 
			Resource = ItsyScape.Resource.Item "Needle",
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 10
		},

		Output { 
			Resource = ItsyScape.Resource.Item "Knife",
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 10
		},

		Output { 
			Resource = ItsyScape.Resource.Item "Hammer",
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 10
		},

		Output { 
			Resource = ItsyScape.Resource.Item "Tinderbox",
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "PlainThread",
			Count = 1,
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 30
		},

		Output {
			Resource = ItsyScape.Resource.Item "BronzePickaxe",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 30
		},

		Output {
			Resource = ItsyScape.Resource.Item "BronzeHatchet",
			Count = 1
		}
	},

	ItsyScape.Action.Buy() {
		Input {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 100
		},

		Output {
			Resource = ItsyScape.Resource.Item "BrownApron",
			Count = 1
		}
	}
}
