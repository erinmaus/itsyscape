--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge/IsabelleIsland_Port.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.PortmasterJenkins.PortmasterJenkins",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Portmaster Jenkins",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Ex-ex-ex-pirate now on the good side of the law, again...",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "SailorsHat",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins"
	}
end

do
	ItsyScape.Resource.Prop "IsabelleIsland_Port_RewardChest" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Sunken chest",
		Resource = ItsyScape.Resource.Prop "IsabelleIsland_Port_RewardChest"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "I wonder what's inside?",
		Resource = ItsyScape.Resource.Prop "IsabelleIsland_Port_RewardChest"
	}

	ItsyScape.Meta.Peep {
		Singleton = 1,
		SingletonID = "IsabelleIsland_Port_RewardChest",
		Resource = ItsyScape.Resource.Prop "IsabelleIsland_Port_RewardChest"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.InstancedBasicChest",
		Resource = ItsyScape.Resource.Prop "IsabelleIsland_Port_RewardChest"
	}
end

do
	ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.UndeadSquid.UndeadSquid",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(1),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Archery",
		Value = ItsyScape.Utility.xpForLevel(55),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Value = ItsyScape.Utility.xpForLevel(55),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Sailing",
		Value = ItsyScape.Utility.xpForLevel(99),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Undead",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Mn'thrw, Undead Squid",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "A squid sacrified to Yendor, now corrupted by the Empty King to protect the island.",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "spawn",
		Tree = "Resources/Game/Peeps/UndeadSquid/UndeadSquid_SpawnLogic.lua",
		IsDefault = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForItem(65),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(60),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(60),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(60),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(20),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(15),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(70),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}

	do
		local SeaBassReward = ItsyScape.Action.Reward() {
			Output {
				Resource = ItsyScape.Resource.Item "SeaBass",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(6)
			}
		}

		ItsyScape.Meta.RewardEntry {
			Action = SeaBassReward,
			Weight = 200
		}

		local SardineReward = ItsyScape.Action.Reward() {
			Output {
				Resource = ItsyScape.Resource.Item "Sardine",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(1)
			}
		}

		ItsyScape.Meta.RewardEntry {
			Action = SardineReward,
			Weight = 400
		}

		local SailorsHatReward = ItsyScape.Action.Reward() {
			Output {
				Resource = ItsyScape.Resource.Item "SailorsHat",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = ItsyScape.Utility.xpForResource(10)
			}
		}

		ItsyScape.Meta.RewardEntry {
			Action = SailorsHatReward,
			Weight = 10
		}

		local FishermansHatReward = ItsyScape.Action.Reward() {
			Output {
				Resource = ItsyScape.Resource.Item "FishermansHat",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(15)
			}
		}

		ItsyScape.Meta.RewardEntry {
			Action = FishermansHatReward,
			Weight = 5
		}

		local BaitReward = ItsyScape.Action.Reward() {
			Output {
				Resource = ItsyScape.Resource.Item "Bait",
				Count = 20
			}
		}

		ItsyScape.Meta.RewardEntry {
			Action = BaitReward,
			Weight = 100
		}

		local CoinsReward = ItsyScape.Action.Reward() {
			Output {
				Resource = ItsyScape.Resource.Item "Coins",
				Count = 100
			}
		}

		ItsyScape.Meta.RewardEntry {
			Action = CoinsReward,
			Weight = 100
		}

		ItsyScape.Resource.DropTable "IsabelleIsland_Port_UndeadSquid_Rewards" {
			SeaBassReward,
			SardineReward,
			SailorsHatReward,
			FishermansHatReward,
			BaitReward,
			CoinsReward
		}
	end
end

do
	local PlugAction = ItsyScape.Action.Pick() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForResource(1)
		}
	}

	ItsyScape.Meta.ActionEvent {
		Event = "IsabelleIsland_Ocean_PlugLeak",
		Action = PlugAction
	}

	ItsyScape.Meta.ActionEventTarget {
		Value = ItsyScape.Resource.Map "IsabelleIsland_Ocean",
		Action = PlugAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Plug",
		XProgressive = "Plugging",
		Language = "en-US",
		Action = PlugAction
	}

	ItsyScape.Resource.Prop "IsabelleIsland_Port_WaterLeak" {
		PlugAction
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1.5,
		SizeY = 3,
		SizeZ = 1.5,
		MapObject = ItsyScape.Resource.Prop "IsabelleIsland_Port_WaterLeak"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BlockingProp",
		Resource = ItsyScape.Resource.Prop "IsabelleIsland_Port_WaterLeak"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Leak",
		Resource = ItsyScape.Resource.Prop "IsabelleIsland_Port_WaterLeak"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "If that's not plugged soon, the ship will sink.",
		Resource = ItsyScape.Resource.Prop "IsabelleIsland_Port_WaterLeak"
	}
end

do
	ItsyScape.Resource.Item "SquidSkull" {
		ItsyScape.Action.Equip() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Archery",
				Count = ItsyScape.Utility.xpForLevel(5)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Dexterity",
				Count = ItsyScape.Utility.xpForLevel(10)
			}
		},

		ItsyScape.Action.Dequip()
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(10),
		Untradeable = 1,
		Resource = ItsyScape.Resource.Item "SquidSkull"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Undead squid skull",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SquidSkull"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "An abomination from the reality warping powers of the Old Ones.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SquidSkull"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForItem(10, 1),
		DefenseStab = -ItsyScape.Utility.styleBonusForItem(10, 0.5),
		DefenseSlash = -ItsyScape.Utility.styleBonusForItem(10, 0.4),
		DefenseCrush = -ItsyScape.Utility.styleBonusForItem(10, 0.3),
		DefenseRanged = -ItsyScape.Utility.styleBonusForItem(10, 1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(10, 1),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(15, 1),
		Prayer = 10,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "SquidSkull"
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/SquidSkull/SquidSkull.lua",
		Resource = ItsyScape.Resource.Item "SquidSkull"
	}

	ItsyScape.Meta.LootCategory {
		Item = ItsyScape.Resource.Item "SquidSkull",
		Category = ItsyScape.Resource.LootCategory "Special"
	}

	local SkullReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "SquidSkull",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = SkullReward,
		Weight = 1
	}

	ItsyScape.Resource.DropTable "IsabelleIsland_Port_UndeadSquid_Rewards_Skull" {
		SkullReward
	}
end
