--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/AncientKaradon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local AncientKaradon = ItsyScape.Resource.Peep "AncientKaradon"

	ItsyScape.Resource.Peep "AncientKaradon" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Fish.AncientKaradon",
		Resource = AncientKaradon
	}

	ItsyScape.Meta.ResourceName {
		Value = "Ancient karadon",
		Language = "en-US",
		Resource = AncientKaradon
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "An angler fish long thought to be extinct; it preys on the souls of humans, damning them to eternal suffering to power its goldfish angler.",
		Language = "en-US",
		Resource = AncientKaradon
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Peeps/Fish/AncientKaradon_AttackLogic.lua",
		Resource = AncientKaradon
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Magic",
		Value = ItsyScape.Utility.xpForLevel(80),
		Resource = AncientKaradon
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Value = ItsyScape.Utility.xpForLevel(80),
		Resource = AncientKaradon
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Archery",
		Value = ItsyScape.Utility.xpForLevel(80),
		Resource = AncientKaradon
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Value = ItsyScape.Utility.xpForLevel(80),
		Resource = AncientKaradon
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(100),
		Resource = AncientKaradon
	}

	ItsyScape.Meta.Equipment {
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(40, 1),
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(40, 1.5),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(45, 1.1),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(45, 1.1),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(45, 1.1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(40, 1.2),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(40, 0.95),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(40),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(45),
		Resource = AncientKaradon
	}
end

do
	local AncientKaradon_Unattackable = ItsyScape.Resource.Peep "AncientKaradon_Unattackable"

	ItsyScape.Meta.ResourceName {
		Value = "Giant lurking fish",
		Language = "en-US",
		Resource = AncientKaradon_Unattackable
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "That's one big fish...",
		Language = "en-US",
		Resource = AncientKaradon_Unattackable
	}
end

do
	local AncientKaradonGoldfish = ItsyScape.Resource.Peep "AncientKaradonGoldfish"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Fish.AncientKaradonGoldfish",
		Resource = AncientKaradonGoldfish
	}

	ItsyScape.Meta.ResourceName {
		Value = "Large goldfish",
		Language = "en-US",
		Resource = AncientKaradonGoldfish
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Didn't know goldfish could get so big...",
		Language = "en-US",
		Resource = AncientKaradonGoldfish
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/Fish/Fish_IdleLogic.lua",
		IsDefault = 1,
		Resource = AncientKaradonGoldfish
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "fish-reel",
		Tree = "Resources/Game/Peeps/Fish/Fish_ReelLogic.lua",
		Resource = AncientKaradonGoldfish
	}
end

do
	local AncientKaradonFishingSpotProxy = ItsyScape.Resource.Prop "AncientKaradonFishingSpotProxy" {
		ItsyScape.Action.Fish() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(40)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Bait",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(40)
			},

			Output {
				Resource = ItsyScape.Resource.Item "AncientKaradonSteak",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.PropAnchor {
		OffsetI = 0,
		OffsetJ = 0,
		Resource = AncientKaradonFishingSpotProxy
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 6.5,
		SizeY = 1,
		SizeZ = 6.5,
		MapObject = AncientKaradonFishingSpotProxy
	}

	ItsyScape.Meta.ResourceName {
		Value = "Mysterious fishing spot",
		Language = "en-US",
		Resource = AncientKaradonFishingSpotProxy
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "There's... a goldfish... swimming in the water...",
		Language = "en-US",
		Resource = AncientKaradonFishingSpotProxy
	}

	ItsyScape.Meta.GatherableProp {
		Health = 1000,
		SpawnTime = math.huge,
		Resource = AncientKaradonFishingSpotProxy
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicFish",
		Resource = AncientKaradonFishingSpotProxy
	}
end

do
	local CookIngredientAction = ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(40)
		},

		Input {
			Resource = ItsyScape.Resource.Item "AncientKaradonSteak",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(40)
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = CookIngredientAction
	}

	ItsyScape.Resource.Item "AncientKaradonSteak" {
		CookIngredientAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "AncientKaradonSteak"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Ancient karadon steak",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AncientKaradonSteak"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Not cooking this fine piece of fish would be an insult.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AncientKaradonSteak"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(40),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "AncientKaradonSteak"
	}

	ItsyScape.Meta.Ingredient {
		Item = ItsyScape.Resource.Item "AncientKaradonSteak",
		Ingredient = ItsyScape.Resource.Ingredient "Fish"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "AncientKaradonSteak",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 20,
		Resource = ItsyScape.Resource.Item "AncientKaradonSteak"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "AncientKaradonSteak",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = ItsyScape.Resource.Item "AncientKaradonSteak",
		Value = ItsyScape.Utility.valueForItem(40)
	}

	local EatAction = ItsyScape.Action.Eat()

	ItsyScape.Meta.HealingPower {
		HitPoints = 20,
		Action = EatAction
	}

	local CookAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(40)
		},

		Input {
			Resource = ItsyScape.Resource.Item "AncientKaradonSteak",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "CookedAncientKaradonSteak",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(40)
		}
	}

	local FailAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(40)
		},

		Input {
			Resource = ItsyScape.Resource.Item "AncientKaradonSteak",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "BurntAncientKaradonSteak",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = 1
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = FailAction
	}

	ItsyScape.Meta.CookingFailedAction {
		Output = FailAction,
		Start = 0,
		Stop = 4,
		Action = CookAction
	}

	ItsyScape.Resource.Item "CookedAncientKaradonSteak" {
		CookAction,
		EatAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedAncientKaradonSteak"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethodFire",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedAncientKaradonSteak"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethodRange",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedAncientKaradonSteak"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Cooked ancient karadon steak",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedAncientKaradonSteak"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "An exquisitely cooked piece of karadon steak that would make a caveman jealous.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedAncientKaradonSteak"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(4),
		Weight = 0.5,
		Resource = ItsyScape.Resource.Item "CookedAncientKaradonSteak"
	}

	ItsyScape.Resource.Item "BurntAncientKaradonSteak" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Value = "Burnt ancient karadon steak",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntAncientKaradonSteak"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Probably should have been a more skilled chef before cooking a steak from an extinct species. Such a shame.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntAncientKaradonSteak"
	}

	ItsyScape.Meta.Item {
		Value = 1,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "BurntAncientKaradonSteak"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "BurntFish",
		Resource = ItsyScape.Resource.Item "BurntAncientKaradonSteak"
	}
end

do
	local AncientKaradonPriest = ItsyScape.Resource.Peep "AncientKaradonPriest"

	ItsyScape.Resource.Peep "AncientKaradonPriest" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "ItsyScape.Peep.Peeps.Player",
		Resource = AncientKaradonPriest
	}

	ItsyScape.Meta.ResourceName {
		Value = "Ancient karadon zealot",
		Language = "en-US",
		Resource = AncientKaradonPriest
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A zealot worshipping the ancient karadon. They will stop at nothing to protect it.",
		Language = "en-US",
		Resource = AncientKaradonPriest
	}

	ItsyScape.Meta.Dummy {
		Hitpoints = 100,

		Weapon = "SpindlyLongbow",
		Shield = "AncientKaradonBuckler",

		Resource = AncientKaradonPriest
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "AncientKaradonBody",
		Count = 1,
		Resource = AncientKaradonPriest
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "AncientKaradonGloves",
		Count = 1,
		Resource = AncientKaradonPriest
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "AncientKaradonBoots",
		Count = 1,
		Resource = AncientKaradonPriest
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "AdamantArrow",
		Count = 10000,
		Resource = AncientKaradonPriest
	}
end



do
	local AncientKaradonScalesReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "AncientKaradonHide",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = AncientKaradonScalesReward,
		Weight = 100
	}

	local BronzeDubloonReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "BronzeDubloon",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Fishing",
			Count = ItsyScape.Utility.xpForResource(55)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = BronzeDubloonReward,
		Weight = 10
	}

	local SilverDubloonReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "SilverDubloon",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Fishing",
			Count = ItsyScape.Utility.xpForResource(55)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = SilverDubloonReward,
		Weight = 10
	}

	local GoldDubloonReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "GoldDubloon",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Fishing",
			Count = ItsyScape.Utility.xpForResource(55)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = GoldDubloonReward,
		Weight = 3
	}

	local KeyReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Key_BlackmeltLagoon1",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Fishing",
			Count = ItsyScape.Utility.xpForResource(41)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = KeyReward,
		Weight = 2
	}

	local LightningStormfishReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "LightningStormfish",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Fishing",
			Count = ItsyScape.Utility.xpForResource(35)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = LightningStormfishReward,
		Weight = 50
	}

	local BlackmeltBassReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "BlackmeltBass",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Fishing",
			Count = ItsyScape.Utility.xpForResource(30)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = BlackmeltBassReward,
		Weight = 100
	}

	local CoelacanthReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Coelacanth",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Fishing",
			Count = ItsyScape.Utility.xpForResource(20)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = CoelacanthReward,
		Weight = 10
	}

	local CrawfishReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Crawfish",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Fishing",
			Count = ItsyScape.Utility.xpForResource(25)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = CrawfishReward,
		Weight = 200
	}

	local ShrimpReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Shrimp",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Fishing",
			Count = ItsyScape.Utility.xpForResource(20)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = ShrimpReward,
		Weight = 400
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
		Weight = 10
	}

	local BaitReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Bait",
			Count = 200
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = BaitReward,
		Weight = 100
	}

	local WaterWormReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "WaterWorm",
			Count = 25
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Fishing",
			Count = ItsyScape.Utility.xpForResource(7.5) * 25
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = WaterWormReward,
		Weight = 100
	}

	local WaterSlugReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "WaterSlug",
			Count = 15
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Fishing",
			Count = ItsyScape.Utility.xpForResource(5.5) * 15
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = WaterSlugReward,
		Weight = 100
	}

	local OldBootReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "OldBoot",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Fishing",
			Count = ItsyScape.Utility.xpForResource(2)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = OldBootReward,
		Weight = 20
	}

	local CoinsReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 15000
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = CoinsReward,
		Weight = 100
	}

	ItsyScape.Resource.DropTable "AncientKaradon_Primary" {
		BronzeDubloonReward,
		SilverDubloonReward,
		GoldDubloonReward,
		KeyReward,
		LightningStormfishReward,
		BlackmeltBassReward,
		CoelacanthReward,
		CrawfishReward,
		ShrimpReward,
		FishermansHatReward,
		WaterWormReward,
		WaterSlugReward,
		OldBootReward,
		BaitReward,
		CoinsReward
	}

	ItsyScape.Resource.DropTable "AncientKaradon_Secondary" {
		AncientKaradonScalesReward
	}
end

do
	local SlimyChest = ItsyScape.Resource.Prop "AncientKaradon_Chest" {

	}

	ItsyScape.Meta.PropAlias {
		Alias = ItsyScape.Resource.Prop "Chest_Default",
		Resource = SlimyChest
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.InstancedBasicChest",
		Resource = SlimyChest
	}

	ItsyScape.Meta.Peep {
		Singleton = 1,
		SingletonID = "AncientKaradon_Chest",
		Resource = SlimyChest
	}

	ItsyScape.Meta.ResourceName {
		Value = "Slimy chest",
		Language = "en-US",
		Resource = SlimyChest
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Looks like a fish spit that chest up...! How disgusting.",
		Language = "en-US",
		Resource = SlimyChest
	}
end
