--------------------------------------------------------------------------------
-- Resources/Game/DB/Init.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "UnfocusedRune" {
	-- Nothing
}

ItsyScape.Meta.ResourceName {
	Value = "Unfocused Rune",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "UnfocusedRune"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(1),
	Resource = ItsyScape.Resource.Item "UnfocusedRune"
}

ItsyScape.Resource.Item "AirRune" {
	-- Nothing
}

ItsyScape.Meta.ResourceName {
	Value = "Air Rune",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AirRune"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(2),
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "AirRune"
}

ItsyScape.Resource.Item "EarthRune" {
	-- Nothing
}

ItsyScape.Meta.ResourceName {
	Value = "Earth Rune",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "EarthRune"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(3),
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "EarthRune"
}

ItsyScape.Resource.Item "WaterRune" {
	-- Nothing
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(4),
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "WaterRune"
}

ItsyScape.Meta.ResourceName {
	Value = "Water Rune",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "WaterRune"
}

ItsyScape.Resource.Item "FireRune" {
	-- Nothing
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(5),
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "FireRune"
}

ItsyScape.Meta.ResourceName {
	Value = "Fire Rune",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "FireRune"
}
