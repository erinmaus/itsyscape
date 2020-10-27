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
	Value = "Unfocused rune",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "UnfocusedRune"
}

ItsyScape.Meta.ResourceDescription {
	Value = "This rune can become any basic rune, the possibilities!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "UnfocusedRune"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(1),
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "UnfocusedRune"
}

ItsyScape.Resource.Item "AirRune" {
	-- Nothing
}

ItsyScape.Resource.Prop "AirObelisk" {
	ItsyScape.Action.Runecraft() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Input {
			Resource = ItsyScape.Resource.Item "UnfocusedRune",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "AirRune",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForResource(1) / 4
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Air obelisk",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "AirObelisk"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The wind swirls around it.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "AirObelisk"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "AirObelisk"
}

ItsyScape.Meta.ResourceName {
	Value = "Air Rune",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AirRune"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Just wants to be free.",
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

ItsyScape.Meta.ResourceDescription {
	Value = "Smells a bit like dirt.",
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

ItsyScape.Meta.ResourceDescription {
	Value = "Slimy!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "WaterRune"
}

ItsyScape.Resource.Prop "CosmicObelisk" {
	ItsyScape.Action.Runecraft() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Input {
			Resource = ItsyScape.Resource.Item "UnfocusedRune",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "CosmicRune",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForResource(5) / 4
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Air obelisk",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "CosmicObelisk"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Feels otherworldly...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "CosmicObelisk"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "CosmicObelisk"
}

ItsyScape.Resource.Item "CosmicRune" {
	-- Nothing
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(20),
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "CosmicRune"
}

ItsyScape.Meta.ResourceName {
	Value = "Cosmic Rune",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "CosmicRune"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Sparkles with a strange, otherworldly energy.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "CosmicRune"
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

ItsyScape.Meta.ResourceDescription {
	Value = "Grind it up and use as it as a spice if you're brave enough!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "FireRune"
}

ItsyScape.Resource.Item "PrimordialTimeRune" {
	-- Nothing
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(10),
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "PrimordialTimeRune"
}

ItsyScape.Meta.ResourceName {
	Value = "Primordial time rune",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "PrimordialTimeRune"
}

ItsyScape.Meta.ResourceDescription {
	Value = "From a time before history...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "PrimordialTimeRune"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(10),
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "AzathothianSpacialRune"
}

ItsyScape.Meta.ResourceName {
	Value = "Azathothian spacial rune",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AzathothianSpacialRune"
}

ItsyScape.Meta.ResourceDescription {
	Value = "If you smash two of 'em together at high enough speed, you'll create a black hole!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AzathothianSpacialRune"
}
