--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Rocks.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Rock_Variant_1" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "Rock_Variant_1"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 1.5,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Rock_Variant_1"
}

ItsyScape.Meta.ResourceName {
	Value = "Big rock",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Rock_Variant_1"
}

ItsyScape.Meta.ResourceDescription {
	Value = "It's obviously just a big rock...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Rock_Variant_1"
}

ItsyScape.Resource.Prop "RockClump_Variant_1" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "RockClump_Variant_1"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 1.5,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "RockClump_Variant_1"
}

ItsyScape.Meta.ResourceName {
	Value = "Clump of rocks",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "RockClump_Variant_1"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The apple doesn't fall far from the tree..",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "RockClump_Variant_1"
}