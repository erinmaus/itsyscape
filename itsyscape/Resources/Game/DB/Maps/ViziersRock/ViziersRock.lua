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

ItsyScape.Resource.Prop "StreetLamp_ViziersRock" {
	-- None.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BlockingProp",
	Resource = ItsyScape.Resource.Prop "StreetLamp_ViziersRock"
}

ItsyScape.Meta.ResourceName {
	Value = "Street lamp",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "StreetLamp_ViziersRock"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Is it powered by gas or magic?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "StreetLamp_ViziersRock"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 8,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "StreetLamp_ViziersRock"
}

ItsyScape.Resource.Prop "Banner_ViziersRock" {
	-- Nothing
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BlockingProp",
	Resource = ItsyScape.Resource.Prop "Banner_ViziersRock"
}

ItsyScape.Meta.ResourceName {
	Value = "Vizier Rock's banner",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Banner_ViziersRock"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 2,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Banner_ViziersRock"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A banner representing Bastiel's omniscience. Or so the Arbitrationists believe...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Banner_ViziersRock"
}

ItsyScape.Resource.Prop "Fireplace_ViziersRock" {
	ItsyScape.Action.Light_Prop() {
		Requirement {
			Resource = ItsyScape.Resource.Item "Tinderbox",
			Count = 1
		}
	},

	ItsyScape.Action.Snuff()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicTorch",
	Resource = ItsyScape.Resource.Prop "Fireplace_ViziersRock"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 1.5,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Fireplace_ViziersRock"
}

ItsyScape.Meta.ResourceName {
	Value = "Fireplace",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Fireplace_ViziersRock"
}

ItsyScape.Meta.ResourceDescription {
	Value = "This might not keep you as warm as you'd think.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Fireplace_ViziersRock"
}
