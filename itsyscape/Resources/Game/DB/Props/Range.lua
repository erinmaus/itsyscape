--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Furniture.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local CookAction = ItsyScape.Action.OpenCraftWindow()
ItsyScape.Meta.DelegatedActionTarget {
	CategoryKey = "CookingMethod",
	CategoryValue = "Range",
	Action = CookAction
}

ItsyScape.Meta.ActionVerb {
	Value = "Cook",
	Language = "en-US",
	Action = CookAction
}

ItsyScape.Resource.Prop "CookingRange_Default" {
	CookAction
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicTableProp",
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

