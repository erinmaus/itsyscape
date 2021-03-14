--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge/IsabelleIsland_FoggyForest.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local ChopAction = ItsyScape.Action.Chop() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Woodcutting",
			Count = ItsyScape.Utility.xpForLevel(0)
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "CopperHatchet",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Woodcutting",
			Count = ItsyScape.Utility.xpForResource(10)
		},

		Output {
			Resource = ItsyScape.Resource.Item "IsabelleIsland_FoggyForest_AncientSplinters",
			Count = 2
		}
	}

	ItsyScape.Meta.ActionDifficulty {
		Value = 1,
		Action = ChopAction
	}

	ItsyScape.Resource.Prop "IsabelleIsland_FoggyForest_AncientDriftwoodTree" {
		ChopAction
	}

	ItsyScape.Meta.GatherableProp {
		Health = 10,
		SpawnTime = math.huge,
		Resource = ItsyScape.Resource.Prop "IsabelleIsland_FoggyForest_AncientDriftwoodTree"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.IsabelleIsland.FoggyForest.AncientDriftwoodTree",
		Resource = ItsyScape.Resource.Prop "IsabelleIsland_FoggyForest_AncientDriftwoodTree"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Ancient driftwood",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "IsabelleIsland_FoggyForest_AncientDriftwoodTree"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Once the oldest oak in the Realm, now a cursed abomination.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "IsabelleIsland_FoggyForest_AncientDriftwoodTree"
	}
end

do
	ItsyScape.Meta.Item {
		Untradeable = 1,
		Resource = ItsyScape.Resource.Item "IsabelleIsland_FoggyForest_KursedGlue"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Kursed glue",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IsabelleIsland_FoggyForest_KursedGlue"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Not suitable for K through 5.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IsabelleIsland_FoggyForest_KursedGlue"
	}
end

do
	ItsyScape.Meta.Item {
		Stackable = 1,
		Untradeable = 1,
		Resource = ItsyScape.Resource.Item "IsabelleIsland_FoggyForest_AncientSplinters"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Ancient splinters",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IsabelleIsland_FoggyForest_AncientSplinters"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Giant splitters cut from the Ancient Driftwood. They're hot to the touch.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IsabelleIsland_FoggyForest_AncientSplinters"
	}

	local CraftAction = ItsyScape.Action.OpenInventoryCraftWindow()

	ItsyScape.Meta.ActionVerb {
		Value = "Craft",
		Language = "en-US",
		Action = CraftAction
	}

	ItsyScape.Meta.DelegatedActionTarget {
		CategoryKey = "Wood",
		CategoryValue = "AncientSplinters",
		Action = CraftAction
	}

	ItsyScape.Resource.Item "IsabelleIsland_FoggyForest_AncientSplinters" {
		CraftAction
	}
end

do
	ItsyScape.Resource.Item "AncientDriftwoodMask" {
		ItsyScape.Action.Equip() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Magic",
				Count = ItsyScape.Utility.xpForLevel(5)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Wisdom",
				Count = ItsyScape.Utility.xpForLevel(10)
			}
		},

		ItsyScape.Action.Dequip(),

		ItsyScape.Action.Craft() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Magic",
				Count = ItsyScape.Utility.xpForLevel(5)
			},

			Input {
				Resource = ItsyScape.Resource.Item "IsabelleIsland_FoggyForest_AncientSplinters",
				Count = 6
			},

			Input {
				Resource = ItsyScape.Resource.Item "IsabelleIsland_FoggyForest_KursedGlue",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForResource(10) * 7
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Magic",
				Count = ItsyScape.Utility.xpForResource(5) * 7
			},

			Output {
				Resource = ItsyScape.Resource.Item "AncientDriftwoodMask",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(10),
		Untradeable = 1,
		Resource = ItsyScape.Resource.Item "AncientDriftwoodMask"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Ancient driftwood mask",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AncientDriftwoodMask"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "It whispers an ancient language...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AncientDriftwoodMask"
	}

	local ARMOR_BODY_WEIGHT = 1
	ItsyScape.Meta.Equipment {
		AccuracyMagic = ItsyScape.Utility.styleBonusForItem(6, 1),
		DefenseStab = -ItsyScape.Utility.styleBonusForItem(5, 0.5),
		DefenseSlash = -ItsyScape.Utility.styleBonusForItem(5, 0.5),
		DefenseCrush = -ItsyScape.Utility.styleBonusForItem(5, 0.5),
		DefenseRanged = -ItsyScape.Utility.styleBonusForItem(10, 1),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(20, 1),
		Prayer = -3,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "AncientDriftwoodMask"
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/AncientDriftwoodMask/AncientDriftwoodMask.lua",
		Resource = ItsyScape.Resource.Item "AncientDriftwoodMask"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Wood",
		Value = "AncientSplinters",
		Resource = ItsyScape.Resource.Item "AncientDriftwoodMask"
	}
end

do
	ItsyScape.Resource.Item "CopperHatchet" {
		ItsyScape.Action.Equip() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Woodcutting",
				Count = 1
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Attack",
				Count = 1
			}
		},

		ItsyScape.Action.Dequip(),
		ItsyScape.Action.Smith() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "Hammer",
				Count = 1
			},

			Requirement {
				Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToGrimm1",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "CopperBar",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForResource(2)
			},

			Output {
				Resource = ItsyScape.Resource.Item "CopperHatchet",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Copper hatchet",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CopperHatchet"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The only hatchet that can break the magical enchantment on the ancient driftwood.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CopperHatchet"
	}

	ItsyScape.Meta.Item {
		Value = 32,
		Weight = 0.0,
		Untradeable = 1,
		Resource = ItsyScape.Resource.Item "CopperHatchet"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = "Copper",
		Resource = ItsyScape.Resource.Item "CopperHatchet"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "WeaponType",
		Value = "hatchet",
		Resource = ItsyScape.Resource.Item "CopperHatchet"
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/CopperHatchet/CopperHatchet.lua",
		Resource = ItsyScape.Resource.Item "CopperHatchet"
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(1),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(1, 0.5),
		Prayer = 2,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "CopperHatchet"
	}
end

do
	ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Nymph_Base_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Nymph_Base_Secondary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "IsabelleIsland_FoggyForest_BossyNymph_Mask",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Undead",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Nymph.BaseNymph",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Bound Nymph",
		Language = "en-US",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Bound to the ancient driftwood tree by the kursed mask.",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Magic",
		Value = ItsyScape.Utility.xpForLevel(5),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Value = ItsyScape.Utility.xpForLevel(5),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(5),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "DinkyStaff",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "WoodlandRobe",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "AncientDriftwoodMask",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "IsabelleIsland_FoggyForest_KursedGlue",
		Weight = 100,
		Count = 1,
		Resource = ItsyScape.Resource.DropTable "IsabelleIsland_FoggyForest_BossyNymph_Mask"	
	}
end

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph_Unattackable" {
		TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph_Unattackable",
		Name = "BossyNymph",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_FoggyForest/Dialog/BossyNymph_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Undead",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph_Unattackable"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Nymph.BaseNymph",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph_Unattackable"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Bound Nymph",
		Language = "en-US",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph_Unattackable"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Bound to the ancient driftwood tree by the kursed mask.",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph_Unattackable"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Magic",
		Value = ItsyScape.Utility.xpForLevel(5),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph_Unattackable"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Value = ItsyScape.Utility.xpForLevel(5),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph_Unattackable"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(1),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph_Unattackable"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph_Unattackable"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "DinkyStaff",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph_Unattackable"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "WoodlandRobe",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph_Unattackable"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "AncientDriftwoodMask",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph_Unattackable"
	}
end

do
	ItsyScape.Resource.Shop "IsabelleIsland_FoggyForest_YendorianIncenseShop" {
		ItsyScape.Action.Buy() {
			Input {
				Count = 5,
				Resource = ItsyScape.Resource.Item "BoneShards"
			},

			Output {
				Count = 1,
				Resource = ItsyScape.Resource.Item "WeakGum"
			}
		},

		ItsyScape.Action.Buy() {
			Input {
				Count = 30,
				Resource = ItsyScape.Resource.Item "BoneShards"
			},

			Output {
				Count = 1,
				Resource = ItsyScape.Resource.Item "CommonLogs"
			}
		},

		ItsyScape.Action.Buy() {
			Input {
				Count = 30,
				Resource = ItsyScape.Resource.Item "BoneShards"
			},

			Output {
				Count = 10,
				Resource = ItsyScape.Resource.Item "FalteringFrankincense"
			}
		},

		ItsyScape.Action.Buy() {
			Input {
				Count = 90,
				Resource = ItsyScape.Resource.Item "BoneShards"
			},

			Output {
				Count = 10,
				Resource = ItsyScape.Resource.Item "FaintEasternBalsam"
			}
		},

		ItsyScape.Action.Buy() {
			Input {
				Count = 1000,
				Resource = ItsyScape.Resource.Item "BoneShards"
			},

			Output {
				Count = 1,
				Resource = ItsyScape.Resource.Item "EldritchMyrrh"
			}
		}
	}

	ItsyScape.Meta.Shop {
		ExchangeRate = 0.1,
		Currency = ItsyScape.Resource.Item "BoneShards",
		Resource = ItsyScape.Resource.Shop "IsabelleIsland_FoggyForest_YendorianIncenseShop"
	}
end
