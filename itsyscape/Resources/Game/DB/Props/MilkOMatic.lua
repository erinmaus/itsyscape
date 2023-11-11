--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Anvil.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local ChurnAction = ItsyScape.Action.OpenCraftWindow()
ItsyScape.Meta.DelegatedActionTarget {
	CategoryKey = "Churn",
	ActionType = "Churn",
	Action = ChurnAction
}

ItsyScape.Meta.ActionVerb {
	Value = "Churn",
	XProgressive = "Churning",
	Language = "en-US",
	Action = ChurnAction
}

ItsyScape.Resource.Prop "MilkOMatic" {
	ChurnAction,

	ItsyScape.Action.UseCraftWindow()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.MilkOMatic.MilkOMatic",
	Resource = ItsyScape.Resource.Prop "MilkOMatic"
}

ItsyScape.Meta.ResourceName {
	Value = "Milk-o-matic",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "MilkOMatic"
}

ItsyScape.Meta.ResourceDescription {
	Value = "State of the art milk processing machine, made by the crazy Techromancer, Hex.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "MilkOMatic"
}
