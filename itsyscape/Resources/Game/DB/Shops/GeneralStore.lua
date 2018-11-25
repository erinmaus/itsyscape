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
		Input = {
			Count = 10,
			Resource = ItsyScape.Resource.Item "Needle",
		}
	},

	ItsyScape.Action.Buy() {
		Input = {
			Count = 1,
			Resource = ItsyScape.Resource.Item "PlainThread",
		}
	},

	ItsyScape.Action.Buy() {
		Input = {
			Count = 1,
			Resource = ItsyScape.Resource.Item "BronzePickaxe",
		}
	},

	ItsyScape.Action.Buy() {
		Input = {
			Count = 1,
			Resource = ItsyScape.Resource.Item "BronzeHatchet",
		}
	}
}
