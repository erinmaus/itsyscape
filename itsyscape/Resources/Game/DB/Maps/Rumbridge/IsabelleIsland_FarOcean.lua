--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge/IsabelleIsland_FarOcean.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Pirate" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Pirate.BasePirate",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Pirate"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Pirate",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Pirate"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Arrrrgh, matey.",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Pirate"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "PiratesHat",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Pirate"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(5),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Pirate"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Sailing",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Pirate"
	}
end

do
	ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Archer" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Human.BaseHuman",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Archer"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Archer",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Archer"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Watch out, he's a bad shot!",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Archer"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "MooishLeatherCoif",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Archer"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "MooishLeatherGloves",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Archer"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "MooishLeatherBoots",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Archer"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "MooishLeatherBody",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Archer"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "MooishLeatherBuckler",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Archer"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "PunyBoomerang",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Archer"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Archer"
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Head/Minifig.lua",
		Slot = ItsyScape.Utility.Equipment.SLOT_HEAD,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Archer"
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes.lua",
		Slot = ItsyScape.Utility.Equipment.SLOT_HEAD,
		Priority = math.huge,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Archer"
	}
end

do
	ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Wizard" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Human.BaseHuman",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Wizard"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Wizard",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Wizard"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "He likes to think he's pretty special.",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Wizard"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlueCottonHat",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Wizard"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlueCottonGloves",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Wizard"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlueCottonSlippers",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Wizard"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlueCottonRobe",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Wizard"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlueCottonShield",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Wizard"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "DinkyStaff",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Wizard"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Wizard"
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Head/Minifig.lua",
		Slot = ItsyScape.Utility.Equipment.SLOT_HEAD,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Wizard"
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes.lua",
		Slot = ItsyScape.Utility.Equipment.SLOT_HEAD,
		Priority = math.huge,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Wizard"
	}
end
