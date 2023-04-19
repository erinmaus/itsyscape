--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/ViziersRock/ViziersRock.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Bartender_Robert" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.ViziersRock.Bartender",
	Resource = ItsyScape.Resource.Peep "Bartender_Robert"
}

ItsyScape.Meta.ResourceName {
	Value = "Robert, Bartender",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Bartender_Robert"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Can mix a mean drink.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Bartender_Robert"
}

local ShopAction = ItsyScape.Action.Shop()

ItsyScape.Meta.ShopTarget {
	Resource = ItsyScape.Resource.Shop "Standard_Crafter",
	Action = ShopAction
}

ItsyScape.Resource.Peep "Crafter_Steve" {
	ShopAction
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.ViziersRock.Crafter",
	Resource = ItsyScape.Resource.Peep "Crafter_Steve"
}

ItsyScape.Meta.ResourceName {
	Value = "Steve, Crafter",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Crafter_Steve"
}

ItsyScape.Meta.ResourceDescription {
	Value = "An excellent crafter.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Crafter_Steve"
}
