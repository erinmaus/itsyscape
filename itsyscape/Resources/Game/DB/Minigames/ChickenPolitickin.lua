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
	ItsyScape.Resource.Peep "Chicken_Haru"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Chicken.HaruChicken",
		Resource = ItsyScape.Resource.Peep "Chicken_Haru"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Chicken",
		Language = "en-US",
		Resource = ItsyScape.Resource.Peep "Chicken_Haru"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Definitely a chicken.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Peep "Chicken_Haru"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "What do you call a chicken's opinion? FeedBAWK!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Peep "Chicken_Haru"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Why did she cross the road? To get to the other side!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Peep "Chicken_Base"
	}
end

do
	local Farmer = ItsyScape.Resource.Peep "ChickenPolitickin_Farmer"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.PanickedHuman.PanickedHuman",
		Resource = Farmer
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Black.lua",
		Priority = math.huge,
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = Farmer
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Shirts/BluePlaid.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = Farmer
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Head/Medium.lua",
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = Farmer
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Hands/Medium.lua",
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = Farmer
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Shoes/LongBoots1.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = Farmer
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "StrawHat",
		Count = 1,
		Resource = Farmer
	}
end
