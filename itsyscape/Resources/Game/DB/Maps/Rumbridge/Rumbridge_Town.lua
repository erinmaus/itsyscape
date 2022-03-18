--------------------------------------------------------------------------------
-- Resources/Game/DB/Peeps/Goblin.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local ShopAction = ItsyScape.Action.Shop()

ItsyScape.Meta.ShopTarget {
	Resource = ItsyScape.Resource.Shop "Standard_Alchemist",
	Action = ShopAction
}

ItsyScape.Resource.Peep "Alchemist_Thernen" {
	ShopAction
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Rumbridge.Alchemist",
	Resource = ItsyScape.Resource.Peep "Alchemist_Thernen"
}

ItsyScape.Meta.ResourceName {
	Value = "Thernen, Alchemist",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Alchemist_Thernen"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Knows a thing or two about magic and runes.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Alchemist_Thernen"
}
