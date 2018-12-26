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

		Output {
			Resource = ItsyScape.Resource.Skill "Woodcutting",
			Count = ItsyScape.Utility.xpForResource(10)
		},

		Output {
			Resource = ItsyScape.Resource.Item "CommonLogs",
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

		ItsyScape.Action.Dequip()
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
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(10, 1),
		Prayer = -3,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "AncientDriftwoodMask"
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/AncientDriftwoodMask/AncientDriftwoodMask.lua",
		Resource = ItsyScape.Resource.Item "AncientDriftwoodMask"
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
		Value = "Bound to the ancient driftwood tree by the cursed mask.",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Magic",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(1),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FoggyForest_BossyNymph"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(15),
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
		Item = ItsyScape.Resource.Item "AncientDriftwoodMask",
		Weight = 100,
		Count = 1,
		Resource = ItsyScape.Resource.DropTable "IsabelleIsland_FoggyForest_BossyNymph_Mask"	
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
