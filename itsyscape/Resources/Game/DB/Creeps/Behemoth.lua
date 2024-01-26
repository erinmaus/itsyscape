--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Behemoth.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Behemoth" {
	ItsyScape.Action.InvisibleAttack()
}

ItsyScape.Meta.ResourceTag {
	Value = "Eldritch",
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.ResourceTag {
	Value = "Mimic",
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Behemoth.Behemoth",
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.ResourceName {
	Value = "Behemoth, Lord of the Mimics",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A mimic shed from Gammon's rocky skin, it took the shape of a fortress and wrought havoc across The Empty Ruins until it was imprisoned by the The Empty King's elite zealots, the Priests of the Simulacrum.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(100),
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(80),
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(80),
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Archery",
	Value = ItsyScape.Utility.xpForLevel(80),
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Dexterity",
	Value = ItsyScape.Utility.xpForLevel(80),
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.Equipment {
	AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(80),
	AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(80),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(80),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(80),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(80),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(45),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(85),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(60),
	StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(60),
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Resource.Peep "Behemoth_Stunned" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Behemoth, Lord of the Mimics",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Behemoth_Stunned"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The Behemoth is stunned! Now climb on to it and mine away at its skin!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Behemoth_Stunned"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Behemoth/Behemoth_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Resource.Prop "BehemothSkin" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Behemoth.BehemothSkin",
	Resource = ItsyScape.Resource.Prop "BehemothSkin"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 0,
	SizeY = 0,
	SizeZ = 0,
	MapObject = ItsyScape.Resource.Prop "BehemothSkin"
}

ItsyScape.Meta.ResourceName {
	Value = "Behemoth's skin",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BehemothSkin"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Makes the Behemoth look cool.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BehemothSkin"
}

ItsyScape.Resource.Prop "BehemothMap" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Behemoth",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BehemothMap"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Climb on to the Behemoth!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BehemothMap"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Behemoth.BehemothMap",
	Resource = ItsyScape.Resource.Prop "BehemothMap"
}

ItsyScape.Meta.PropAnchor {
	OffsetI = 0,
	OffsetJ = 0,
	Resource = ItsyScape.Resource.Prop "BehemothMap"
}

local ClimbAction = ItsyScape.Action.Travel()

ItsyScape.Meta.ActionVerb {
	Value = "Climb",
	Language = "en-US",
	XProgressive = "Climbing",
	Action = ClimbAction
}

ItsyScape.Resource.Prop "BehemothMap_Climbable" {
	ClimbAction	
}

ItsyScape.Meta.ResourceName {
	Value = "Behemoth",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BehemothMap_Climbable"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Climb on to the Behemoth!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BehemothMap_Climbable"
}

do
	local BehemothMimicToothReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "BehemothMimicTooth",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = BehemothMimicToothReward,
		Weight = 499
	}

	local MimicPickaxeReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "MimicPickaxe",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = MimicPickaxeReward,
		Weight = 1
	}

	local CoarseSageRockSaltReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "CoarseSageRockSalt",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = CoarseSageRockSaltReward,
		Weight = 10
	}

	local CoarseDexterousRockSaltReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "CoarseDexterousRockSalt",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = CoarseDexterousRockSaltReward,
		Weight = 10
	}

	local CoarseKosherRockSaltReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "CoarseKosherRockSalt",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = CoarseKosherRockSaltReward,
		Weight = 10
	}

	local CoarseWarriorRockSaltReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "CoarseWarriorRockSalt",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = CoarseWarriorRockSaltReward,
		Weight = 10
	}

	local CoarseToughRockSaltReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "CoarseToughRockSalt",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = CoarseToughRockSaltReward,
		Weight = 10
	}

	local CoarseArtisanRockSaltReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "CoarseArtisanRockSalt",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = CoarseArtisanRockSaltReward,
		Weight = 10
	}

	local CoarseGathererRockSaltReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "CoarseGathererRockSalt",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = CoarseGathererRockSaltReward,
		Weight = 10
	}

	local CoarseAdventurerRockSaltReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "CoarseAdventurerRockSalt",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = CoarseAdventurerRockSaltReward,
		Weight = 10
	}

	local CopperReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "CopperOre",
			Count = 2
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForResource(1)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = CopperReward,
		Weight = 100
	}

	local TinReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "TinOre",
			Count = 2
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForResource(1)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = TinReward,
		Weight = 100
	}

	local IronReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "IronOre",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForResource(10)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = IronReward,
		Weight = 100
	}

	local CoalReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "CoalOre",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForResource(20)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = CoalReward,
		Weight = 100
	}

	local LithiumReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "LithiumOre",
			Count = 2
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForResource(25)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = LithiumReward,
		Weight = 50
	}

	local MithrilReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "MithrilOre",
			Count = 2
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForResource(30)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = MithrilReward,
		Weight = 50
	}

	local CaesiumReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "CaesiumOre",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForResource(35)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = CaesiumReward,
		Weight = 25
	}

	local AdamantReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "AdamantOre",
			Count = 2
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForResource(40)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = AdamantReward,
		Weight = 25
	}

	local UraniumReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "UraniumOre",
			Count = 2
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForResource(45)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = UraniumReward,
		Weight = 25
	}

	local ItsyReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "ItsyOre",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForResource(50)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = ItsyReward,
		Weight = 25
	}

	local GoldReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "GoldOre",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForResource(55)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = GoldReward,
		Weight = 10
	}

	ItsyScape.Resource.DropTable "Behemoth_Primary" {
		CopperReward,
		TinReward,
		IronReward,
		CoalReward,
		LithiumReward,
		MithrilReward,
		CaesiumReward,
		AdamantReward,
		UraniumReward,
		ItsyReward,
		GoldReward
	}

	ItsyScape.Resource.DropTable "Behemoth_Secondary" {
		CoarseSageRockSaltReward,
		CoarseDexterousRockSaltReward,
		CoarseKosherRockSaltReward,
		CoarseWarriorRockSaltReward,
		CoarseToughRockSaltReward,
		CoarseArtisanRockSaltReward,
		CoarseGathererRockSaltReward,
		CoarseAdventurerRockSaltReward
	}

	ItsyScape.Resource.DropTable "Behemoth_Tertiary" {
		BehemothMimicToothReward,
		MimicPickaxeReward
	}
end

do
	local DustyChest = ItsyScape.Resource.Prop "Behemoth_Chest"

	ItsyScape.Meta.PropAlias {
		Alias = ItsyScape.Resource.Prop "Chest_Default",
		Resource = DustyChest
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.InstancedBasicChest",
		Resource = DustyChest
	}

	ItsyScape.Meta.Peep {
		Singleton = 1,
		SingletonID = "Behemoth_Chest",
		Resource = DustyChest
	}

	ItsyScape.Meta.ResourceName {
		Value = "Dusty chest",
		Language = "en-US",
		Resource = DustyChest
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "This chest is dusty! Opening it will surely make you sneeze.",
		Language = "en-US",
		Resource = DustyChest
	}
end

do
	local BehemothTooth = ItsyScape.Resource.Item "BehemothMimicTooth"

	ItsyScape.Meta.ResourceName {
		Value = "Behemoth mimic tooth",
		Language = "en-US",
		Resource = BehemothTooth
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A mimic tooth from the Behemoth. Can be crafted into a loot bag!",
		Language = "en-US",
		Resource = BehemothTooth
	}

	ItsyScape.Meta.LootCategory {
		Item = BehemothTooth,
		Category = ItsyScape.Resource.LootCategory "Special"
	}

	ItsyScape.Meta.Item {
		Value = (ItsyScape.Utility.valueForItem(65) * 15) / 100,
		Stackable = 1,
		Resource = BehemothTooth
	}

	local CraftAction = ItsyScape.Action.OpenInventoryCraftWindow()

	ItsyScape.Meta.ActionVerb {
		Value = "Craft",
		XProgressive = "Crafting",
		Language = "en-US",
		Action = CraftAction
	}

	ItsyScape.Meta.DelegatedActionTarget {
		CategoryKey = "Loot",
		CategoryValue = "Behemoth",
		ActionType = "Craft",
		Action = CraftAction
	}

	BehemothTooth {
		CraftAction
	}
end

do
	local LootBag = ItsyScape.Resource.Item "BehemothLootBag" {
		ItsyScape.Action.Craft() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "BehemothMimicTooth",
				Count = 100
			},

			Input {
				Resource = ItsyScape.Resource.Item "ItsyPickaxe",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "BehemothLootBag",
				Count = 1
			}
		},

		ItsyScape.Action.LootBag() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Behemoth_LootBag",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Behemoth's loot bag",
		Language = "en-US",
		Resource = LootBag
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Contains a legendary item from fighting the Behemoth. Be careful, it might bite!",
		Language = "en-US",
		Resource = LootBag
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Loot",
		Value = "Behemoth",
		Resource = LootBag
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(65) * 15,
		Resource = LootBag
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "MimicPickaxe",
		Weight = 100,
		Count = 1,
		Resource = ItsyScape.Resource.DropTable "Behemoth_LootBag"
	}
end

do
	local MimicPickaxe = ItsyScape.Resource.Item "MimicPickaxe" {
		ItsyScape.Action.Equip() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Attack",
				Count = ItsyScape.Utility.xpForLevel(55)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForLevel(55)
			}
		},

		ItsyScape.Action.Dequip(),

		ItsyScape.Action.ObtainSecondary() {
			Output {
				Resource = ItsyScape.Resource.Item "CoarseSageRockSalt",
				Count = 1
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Output {
				Resource = ItsyScape.Resource.Item "CoarseDexterousRockSalt",
				Count = 1
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Output {
				Resource = ItsyScape.Resource.Item "CoarseKosherRockSalt",
				Count = 1
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Output {
				Resource = ItsyScape.Resource.Item "CoarseWarriorRockSalt",
				Count = 1
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Output {
				Resource = ItsyScape.Resource.Item "CoarseToughRockSalt",
				Count = 1
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Output {
				Resource = ItsyScape.Resource.Item "CoarseArtisanRockSalt",
				Count = 1
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Output {
				Resource = ItsyScape.Resource.Item "CoarseGathererRockSalt",
				Count = 1
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Output {
				Resource = ItsyScape.Resource.Item "CoarseAdventurerRockSalt",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(60),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(60),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = MimicPickaxe
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(65) * 15,
		Weight = 0,
		Resource = MimicPickaxe
	}

	ItsyScape.Meta.LootCategory {
		Item = ItsyScape.Resource.Item "MimicPickaxe",
		Category = ItsyScape.Resource.LootCategory "Legendary"
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/MimicPickaxe/MimicPickaxe.lua",
		Resource = MimicPickaxe
	}

	ItsyScape.Meta.ResourceName {
		Value = "Mimic pickaxe",
		Language = "en-US",
		Resource = MimicPickaxe
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A pickaxe shed from the Behemoth. Extracts rare coarse rock salts while mining... But at what cost?",
		Language = "en-US",
		Resource = MimicPickaxe
	}

	ItsyScape.Meta.ResourceName {
		Value = "Mimic pickaxe drool",
		Language = "en-US",
		Resource = ItsyScape.Resource.Effect "MimicPickaxe"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Extracts rare coarse rock salts while mining.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Effect "MimicPickaxe"
	}
end
