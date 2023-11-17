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

do
	local Dandy = ItsyScape.Resource.Peep "Dandy" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Dandy_Primary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Flowers.Dandy",
		Resource = Dandy
	}

	ItsyScape.Meta.ResourceName {
		Value = "Dandy",
		Language = "en-US",
		Resource = Dandy
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A weed with attitude.",
		Language = "en-US",
		Resource = Dandy
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = Dandy
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(15),
		Resource = Dandy
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Dandy
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Dandy
	}

	ItsyScape.Meta.Equipment {
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(20),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(10),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(1),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(10),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(15),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(15),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(10),
		Resource = Dandy
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/Flowers/Dandy_IdleLogic.lua",
		IsDefault = 1,
		Resource = Dandy
	}
end

do
	local DeadDandy = ItsyScape.Resource.Peep "DeadDandy" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Dandy_Primary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Flowers.DeadDandy",
		Resource = DeadDandy
	}

	ItsyScape.Meta.ResourceName {
		Value = "Dead dandy",
		Language = "en-US",
		Resource = DeadDandy
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "If your spring allergies are bad, fighting a dead dandy is not a good idea.",
		Language = "en-US",
		Resource = DeadDandy
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = DeadDandy
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(1),
		Resource = DeadDandy
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Magic",
		Value = ItsyScape.Utility.xpForLevel(25),
		Resource = DeadDandy
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Value = ItsyScape.Utility.xpForLevel(25),
		Resource = DeadDandy
	}

	ItsyScape.Meta.Equipment {
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(25),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(15),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(15),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(15),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(25),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(1),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(28),
		Resource = DeadDandy
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Undead",
		Resource = DeadDandy
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/Flowers/Dandy_IdleLogic.lua",
		IsDefault = 1,
		Resource = DeadDandy
	}
end

do
	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "SuperSupperSaboteur_DandelionFlour",
		Weight = 1,
		Count = 1,
		Resource = ItsyScape.Resource.DropTable "Dandy_Primary"
	}
end
