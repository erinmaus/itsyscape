--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Shops.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

-- Butcher shop
do
	ItsyScape.Resource.Prop "Shop_Butcher_HangingBeef" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BlockingProp",
		Resource = ItsyScape.Resource.Prop "Shop_Butcher_HangingBeef"
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1.5,
		SizeY = 3,
		SizeZ = 1.5,
		MapObject = ItsyScape.Resource.Prop "Shop_Butcher_HangingBeef"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Butchered cow",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Shop_Butcher_HangingBeef"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Pretty metal... because beef is high in iron.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Shop_Butcher_HangingBeef"
	}

	ItsyScape.Resource.Prop "Shop_Butcher_HangingPork" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BlockingProp",
		Resource = ItsyScape.Resource.Prop "Shop_Butcher_HangingPork"
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1.5,
		SizeY = 3,
		SizeZ = 1.5,
		MapObject = ItsyScape.Resource.Prop "Shop_Butcher_HangingPork"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Butchered piggy",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Shop_Butcher_HangingPork"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "This piggy oinked its last oink... Being a vegetarian is starting to make sense!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Shop_Butcher_HangingPork"
	}
end
