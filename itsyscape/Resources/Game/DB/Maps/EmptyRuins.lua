--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/EmptyRuins.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Door_EmptyRuins" {
	ItsyScape.Action.Open(),
	ItsyScape.Action.Close()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicDoor",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins"
}

ItsyScape.Meta.ResourceName {
	Value = "Squeaky door",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 4,
	SizeZ = 0.5,
	MapObject = ItsyScape.Resource.Prop "Door_EmptyRuins"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Might be better to ignore what's behind that door...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins"
}

ItsyScape.Resource.Prop "Door_EmptyRuins_Single" {
	ItsyScape.Action.Open(),
	ItsyScape.Action.Close()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicDoor",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Single"
}

ItsyScape.Meta.ResourceName {
	Value = "Squeaky door",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Single"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 4,
	SizeZ = 0.5,
	MapObject = ItsyScape.Resource.Prop "Door_EmptyRuins_Single"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Probably don't wanna open that door...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Single"
}

ItsyScape.Resource.Prop "Door_EmptyRuins_Locked" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicDoor",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Locked"
}

ItsyScape.Meta.ResourceName {
	Value = "Squeaky door",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Locked"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 4,
	SizeZ = 0.5,
	MapObject = ItsyScape.Resource.Prop "Door_EmptyRuins_Locked"
}

ItsyScape.Meta.PropAlias {
	Alias = ItsyScape.Resource.Prop "Door_EmptyRuins",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Locked"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Might be better to ignore what's behind that door...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Locked"
}

ItsyScape.Resource.Prop "Door_EmptyRuins_Single_Locked" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicDoor",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Single_Locked"
}

ItsyScape.Meta.ResourceName {
	Value = "Squeaky door",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Single_Locked"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 4,
	SizeZ = 0.5,
	MapObject = ItsyScape.Resource.Prop "Door_EmptyRuins_Single_Locked"
}

ItsyScape.Meta.ResourceDescription {
	Value = 7,
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Single_Locked"
}

ItsyScape.Meta.PropAlias {
	Alias = ItsyScape.Resource.Prop "Door_EmptyRuins",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Single_Locked"
}
