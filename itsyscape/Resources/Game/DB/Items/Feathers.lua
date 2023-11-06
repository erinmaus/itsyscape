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

ItsyScape.Resource.Item "GoldenFeather" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Golden feather",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GoldenFeather"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Kinda heavy for a feather!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GoldenFeather"
}

ItsyScape.Meta.Item {
	Value = math.floor(ItsyScape.Utility.valueForItem(20) / 5 + 0.5),
	Weight = 10,
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "GoldenFeather"
}

ItsyScape.Resource.Item "IslandFeather" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Island feather",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IslandFeather"
}

ItsyScape.Meta.ResourceDescription {
	Value = "What a pretty feather.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IslandFeather"
}

ItsyScape.Meta.Item {
	Value = 10,
	Weight = 1,
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "IslandFeather"
}
