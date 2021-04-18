--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Furnace.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local FurnaceAction = ItsyScape.Action.OpenCraftWindow()
ItsyScape.Meta.DelegatedActionTarget {
	CategoryKey = "Metal",
	ActionType = "Smelt",
	Action = FurnaceAction
}

ItsyScape.Meta.ActionVerb {
	Value = "Smelt",
	XProgressive = "Smelting",
	Language = "en-US",
	Action = FurnaceAction
}

ItsyScape.Resource.Prop "Furnace_Default" {
	FurnaceAction,

	ItsyScape.Action.UseCraftWindow()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicFurnace",
	Resource = ItsyScape.Resource.Prop "Furnace_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Furnace",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Furnace_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Hot enough to melt most things.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Furnace_Default"
}
