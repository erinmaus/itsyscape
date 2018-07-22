--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Anvil.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local AnvilAction = ItsyScape.Action.OpenCraftWindow()
ItsyScape.Meta.DelegatedActionTarget {
	CategoryKey = "Metal",
	ActionType = "Smith",
	Action = AnvilAction
}

ItsyScape.Meta.ActionVerb {
	Value = "Smith",
	Language = "en-US",
	Action = AnvilAction
}

ItsyScape.Resource.Prop "Anvil_Default" {
	AnvilAction
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicAnvil",
	Resource = ItsyScape.Resource.Prop "Anvil_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Anvil",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Anvil_Default"
}
