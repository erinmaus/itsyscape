--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge/Rumbridge_Farm.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Farmer = ItsyScape.Resource.Peep "Rumbridge_Farmer"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Human.BaseHuman",
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

	ItsyScape.Meta.ResourceName {
		Value = "Grumpy farmer",
		Language = "en-US",
		Resource = Farmer
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "He's had enough of beating sense into vegetables.",
		Language = "en-US",
		Resource = Farmer
	}
end
