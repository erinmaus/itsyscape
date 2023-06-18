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
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(60, 1),
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(60, 1.5),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(65, 1.1),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(65, 1.1),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(65, 1.1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(40, 1.2),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(40, 0.95),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(55),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(50),
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
			}
		}
	}

	ItsyScape.Meta.PropAnchor {
		OffsetI = 0,
		OffsetJ = 0,
		Resource = AncientKaradonFishingSpotProxy
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
		Health = 5,
		SpawnTime = math.huge,
		Resource = AncientKaradonFishingSpotProxy
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicFish",
		Resource = AncientKaradonFishingSpotProxy
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
