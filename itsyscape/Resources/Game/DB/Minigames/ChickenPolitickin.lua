--------------------------------------------------------------------------------
-- Resources/Game/DB/Minigames/ChickenPolitickin.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
do
	local Chicken = ItsyScape.Resource.Peep "Chicken_Haru" {
		ItsyScape.Action.InvisibleAttack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Chicken.HaruChicken",
		Resource = Chicken
	}

	ItsyScape.Meta.ResourceName {
		Value = "Chicken",
		Language = "en-US",
		Resource = Chicken
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Definitely a chicken.",
		Language = "en-US",
		Resource = Chicken
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "What do you call a chicken's opinion? FeedBAWK!",
		Language = "en-US",
		Resource = Chicken
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Why did she cross the road? To get to the other side!",
		Language = "en-US",
		Resource = Chicken
	}
end

do
	local Farmer = ItsyScape.Resource.Peep "ChickenPolitickin_Farmer"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.PanickedHuman.PanickedHuman",
		Resource = Farmer
	}

	ItsyScape.Utility.skins(Farmer, {
		{
			filename = "PlayerKit2/Head/Humanlike.lua",
			slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			colors = {
				"SKIN_MEDIUM"
			}
		},
		{
			filename = "PlayerKit2/Eyes/Eyes.lua",
			slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			priority = math.huge,
			colors = {
				"HAIR_BLACK",
				"EYE_WHITE",
				"EYE_BLACK"
			}
		},
		{
			filename = "PlayerKit2/Shirts/Plaid.lua",
			slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
			priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			colors = {
				"PRIMARY_BLUE",
				"PRIMARY_BROWN",
				"PRIMARY_GREY",
				"PRIMARY_BLACK",
				"PRIMARY_WHITE"
			}
		},
		{
			filename = "PlayerKit2/Hands/Humanlike.lua",
			slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			colors = {
				"SKIN_MEDIUM"
			}
		},
		{
			filename = "PlayerKit2/Shoes/LongBoots1.lua",
			slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			colors = {
				"PRIMARY_BLACK"
			}
		},
	})

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "StrawHat",
		Count = 1,
		Resource = Farmer
	}

	ItsyScape.Meta.ResourceName {
		Value = "Farmer",
		Language = "en-US",
		Resource = Farmer
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Definitely a chicken farmer.",
		Language = "en-US",
		Resource = Farmer
	}
end
