--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Farm.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Trough_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.FurnitureProp",
	Resource = ItsyScape.Resource.Prop "Trough_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 1.5,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Trough_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Trough",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Trough_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Full of food for large farm animals.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Trough_Default"
}

ItsyScape.Resource.Prop "Hay_Default" {
	-- None.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.FurnitureProp",
	Resource = ItsyScape.Resource.Prop "Hay_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Hay",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Hay_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Just looking at it makes you itchy!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Hay_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 1.5,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Hay_Default"
}

