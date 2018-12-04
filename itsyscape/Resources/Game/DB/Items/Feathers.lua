--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Feathers.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "Feather" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Feather",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Feather"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Absolutely ticklish!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Feather"
}

ItsyScape.Meta.Item {
	Value = 1,
	Weight = 1,
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "Feather"
}
