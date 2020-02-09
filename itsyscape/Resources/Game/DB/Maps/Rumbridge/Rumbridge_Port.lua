do
	local GuildMaster = ItsyScape.Resource.Peep "Rumbridge_Port_SeafarerGuildmaster"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.SeafarerGuildMaster.SeafarerGuildMaster",
		Resource = GuildMaster
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Shirts/SeafarerGarb.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = GuildMaster
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots_Seafarer1.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = GuildMaster
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Brown.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Priority = math.huge,
		Resource = GuildMaster
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Shirts/SeafarerGloves.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = GuildMaster
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Hands/SeafarerGloves.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = GuildMaster
	}


	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Head/Medium.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = GuildMaster
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Hair/SlickPokey_Seafarer.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
		Resource = GuildMaster
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/SeafarerHat/SeafarerHat.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_EQUIPMENT,
		Resource = GuildMaster
	}

	ItsyScape.Meta.ResourceName {
		Value = "Robert, Seafarer Guild Master",
		Language = "en-US",
		Resource = GuildMaster
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "First of his name.",
		Language = "en-US",
		Resource = GuildMaster
	}
end
