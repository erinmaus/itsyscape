--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Furniture.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "DiningTable_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "DiningTable_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 2,
	SizeZ = 5.5,
	MapObject = ItsyScape.Resource.Prop "DiningTable_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Dining table",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "DiningTable_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Look at all that food!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "DiningTable_Default"
}

ItsyScape.Resource.Prop "DiningTableChair_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "DiningTableChair_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 1,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "DiningTableChair_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Dining stool",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "DiningTableChair_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Not the comfiest, but fooooooood!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "DiningTableChair_Default"
}
