--------------------------------------------------------------------------------
-- Resources/Game/DB/Trailer/Trailer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	ItsyScape.Resource.Peep "CinematicTrailer1_Archer" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Trailer.Archer",
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Archer"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Archer",
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Archer"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Watch out, he's a bad shot!",
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Archer"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "MooishLeatherCoif",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Archer"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "MooishLeatherGloves",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Archer"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "MooishLeatherBoots",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Archer"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "MooishLeatherBody",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Archer"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "PunyLongbow",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Archer"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BronzeArrow",
		Count = 10000000,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Archer"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Archer"
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Head/Minifig.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Archer"
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Priority = math.huge,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Archer"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(150),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(150),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Archer"
	}
end

do
	ItsyScape.Resource.Peep "CinematicTrailer1_Wizard" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Trailer.Wizard",
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Wizard"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Wizard",
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Wizard"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "He likes to think he's pretty special.",
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Wizard"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlueCottonHat",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Wizard"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlueCottonGloves",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Wizard"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlueCottonSlippers",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Wizard"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlueCottonRobe",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Wizard"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlueCottonShield",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Wizard"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "DinkyStaff",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Wizard"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Wizard"
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Head/Minifig.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Wizard"
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Priority = math.huge,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Wizard"
	}

	ItsyScape.Meta.Equipment {
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(150),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(150),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Wizard"
	}
end

do
	ItsyScape.Resource.Peep "CinematicTrailer1_Warrior" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Trailer.Archer",
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Warrior"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Archer",
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Warrior"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Watch out, he's a bad shot!",
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Warrior"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ItsyHelmet",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Warrior"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ItsyGloves",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Warrior"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ItsyBoots",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Warrior"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ItsyPlatebody",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Warrior"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ItsyShield",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Warrior"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ItsyLongsword",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Warrior"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Warrior"
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Head/Minifig.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Warrior"
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Priority = math.huge,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Warrior"
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(150),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(150),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = ItsyScape.Resource.Peep "CinematicTrailer1_Warrior"
	}
end
