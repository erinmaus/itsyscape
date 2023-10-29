--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge/Rumbridge_Town.lua
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

local ShopAction = ItsyScape.Action.Shop()

ItsyScape.Meta.ShopTarget {
	Resource = ItsyScape.Resource.Shop "Standard_Butcher",
	Action = ShopAction
}

ItsyScape.Resource.Peep "Butcher_Urgo" {
	ShopAction
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Rumbridge.Butcher",
	Resource = ItsyScape.Resource.Peep "Butcher_Urgo"
}

ItsyScape.Meta.ResourceName {
	Value = "Urgo, Butcher",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Butcher_Urgo"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Likes cutting meat.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Butcher_Urgo"
}

ItsyScape.Resource.Peep "Lyra" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Lyra.Lyra",
	Resource = ItsyScape.Resource.Peep "Lyra"
}

ItsyScape.Meta.ResourceName {
	Value = "Lyra",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Lyra"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A member of witch society, she yearns to learn more about the nature of magic.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Lyra"
}

ItsyScape.Resource.Peep "Oliver" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Oliver.Oliver",
	Resource = ItsyScape.Resource.Peep "Oliver"
}

ItsyScape.Meta.ResourceName {
	Value = "Oliver",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Oliver"
}

ItsyScape.Meta.ResourceDescription {
	Value = "What kind of dog is that?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Oliver"
}
