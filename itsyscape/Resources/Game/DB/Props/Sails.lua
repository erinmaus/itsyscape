--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Sails.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Sailing_Player_CommonSail" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicPlayerSail",
	Resource = ItsyScape.Resource.Prop "Sailing_Player_CommonSail"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 2,
	SizeY = 7,
	SizeZ = 12,
	OffsetX = -2,
	OffsetY = 5.5,
	MapObject = ItsyScape.Resource.Prop "Sailing_Player_CommonSail"
}

ItsyScape.Meta.ResourceName {
	Value = "Common sail",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Sailing_Player_CommonSail"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Just the most basic of sails, but it works well enough.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Sailing_Player_CommonSail"
}

ItsyScape.Resource.Prop "Sailing_BasicSail_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.PassableProp",
	Resource = ItsyScape.Resource.Prop "Sailing_BasicSail_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 2,
	SizeY = 7,
	SizeZ = 12,
	OffsetX = -2,
	OffsetY = 5.5,
	MapObject = ItsyScape.Resource.Prop "Sailing_BasicSail_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Basic sail",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Sailing_BasicSail_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Full of wind.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Sailing_BasicSail_Default"
}

ItsyScape.Resource.Prop "Sailing_BasicSail_Pirate_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.PassableProp",
	Resource = ItsyScape.Resource.Prop "Sailing_BasicSail_Pirate_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 2,
	SizeY = 7,
	SizeZ = 12,
	OffsetX = -2,
	OffsetY = 5.5,
	MapObject = ItsyScape.Resource.Prop "Sailing_BasicSail_Pirate_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Pirate's sail",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Sailing_BasicSail_Pirate_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Bearing the skull and crossbones, beware!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Sailing_BasicSail_Pirate_Default"
}

ItsyScape.Resource.Prop "Sailing_Player_RumbridgeNavySail" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicPlayerSail",
	Resource = ItsyScape.Resource.Prop "Sailing_Player_RumbridgeNavySail"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 2,
	SizeY = 7,
	SizeZ = 12,
	OffsetX = -2,
	OffsetY = 5.5,
	MapObject = ItsyScape.Resource.Prop "Sailing_Player_RumbridgeNavySail"
}

ItsyScape.Meta.ResourceName {
	Value = "Rumbridge navy sail",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Sailing_Player_RumbridgeNavySail"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Won't scare any pirates, but gives relief to merchants.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Sailing_Player_RumbridgeNavySail"
}
