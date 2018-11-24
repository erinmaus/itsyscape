--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Currency.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	ItsyScape.Resource.Item "Coins" {
		-- Nothing.
	}

	ItsyScape.Meta.Item {
		Weight = 0,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "Coins"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Coins",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Coins"
	}
end
