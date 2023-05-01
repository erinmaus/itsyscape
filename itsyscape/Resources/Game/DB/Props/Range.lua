--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Furniture.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local CookAction1 = ItsyScape.Action.OpenCraftWindow()
ItsyScape.Meta.DelegatedActionTarget {
	CategoryKey = "CookingMethod",
	CategoryValue = "Range",
	Action = CookAction1
}

ItsyScape.Meta.ActionVerb {
	Value = "Cook",
	XProgressive = "Cook",
	Language = "en-US",
	Action = CookAction1
}

local CookAction2 = ItsyScape.Action.OpenCookingWindow()
ItsyScape.Meta.ActionVerb {
	Value = "Cook-fancy",
	XProgressive = "Cooking-fancy",
	Language = "en-US",
	Action = CookAction2
}

ItsyScape.Resource.Prop "CookingRange_Default" {
	CookAction1,
	CookAction2
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.FurnitureProp",
	Resource = ItsyScape.Resource.Prop "CookingRange_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 2,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "CookingRange_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Cooking range",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "CookingRange_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Kitchen wizardry ahead of its time!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "CookingRange_Default"
}

