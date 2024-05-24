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

	ItsyScape.Utility.skins(GuildMaster, {
		{	
			filename = "PlayerKit2/Head/Humanlike.lua",
			slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			colors = {
				"SKIN_MEDIUM"
			}
		},
		{
			filename = "PlayerKit2/Hair/SlickPokey.lua",
			slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
			colors = {
				"HAIR_BROWN"
			}
		},
		{
			filename = "SeafarerHat/SeafarerHat.lua",
			slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_EQUIPMENT,
		},
		{
			filename = "PlayerKit2/Eyes/Eyes.lua",
			slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
			priority = math.huge,
			colors = {
				"HAIR_BROWN",
				"EYE_WHITE",
				"EYE_BLACK"
			}
		},
		{
			filename = "PlayerKit2/Shirts/FancyRobe.lua",
			slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
			priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			colors = {
				"PRIMARY_WHITE",
				"PRIMARY_BLUE",
				"PRIMARY_YELLOW"
			}
		},
		{
			filename = "PlayerKit2/Hands/StripedGloves.lua",
			slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
			priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			colors = {
				"PRIMARY_BLUE",
				"PRIMARY_YELLOW"
			}
		},
		{
			filename = "PlayerKit2/Shoes/Boots_Seafarer1.lua",
			slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
			priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
			colors = {
				"PRIMARY_BROWN"
			}
		},
	})

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
