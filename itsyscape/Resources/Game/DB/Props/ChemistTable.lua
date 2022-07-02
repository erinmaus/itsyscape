--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/ChemistTable.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local MixAction = ItsyScape.Action.OpenCraftWindow()
ItsyScape.Meta.DelegatedActionTarget {
	CategoryKey = "Chemical",
	ActionType = "Mix",
	Action = MixAction
}

ItsyScape.Meta.ActionVerb {
	Value = "Mix",
	XProgressive = "Mixing",
	Language = "en-US",
	Action = MixAction
}

ItsyScape.Resource.Prop "ChemistTable_Default" {
	MixAction
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "ChemistTable_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 3,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "ChemistTable_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Chemist's mixing table",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "ChemistTable_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Mad science mad accessible.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "ChemistTable_Default"
}
