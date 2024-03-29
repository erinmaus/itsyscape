--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/MagicWeapons.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local TIERS = {
	["Dinky"] = {
		tier = 1,
		weight = 8,
		wood = "Common"
	},

	["Feeble"] = {
		tier = 10,
		weight = 8,
		wood = "Willow"
	},

	["Moldy"] = {
		tier = 20,
		weight = 3.7,
		wood = "Oak"
	},

	["Springy"] = {
		tier = 30,
		weight = 4.2,
		wood = "Maple"
	},

	["Tense"] = {
		tier = 40,
		weight = 3.1,
		wood = "Yew"
	},

	["Scary"] = {
		tier = 50,
		weight = 1.7,
		wood = "PetrifiedSpider"
	},

	["Fungal"] = {
		tier = 90,
		weight = -6,
		wood = "Azathothian",
		tertiary = "BlackTalon"
	}
}

local ITEMS = {
	["Wand"] = {
		niceName = "%s wand",
		logs = 1
	},


	["Cane"] = {
		niceName = "%s cane",
		logs = 2,
	},

	["Staff"] = {
		niceName = "%s staff",
		logs = 5
	}
}

for name, tier in spairs(TIERS) do
	for itemName, itemProps in spairs(ITEMS) do
		local ItemName = string.format("%s%s", name, itemName)
		local Item = ItsyScape.Resource.Item(ItemName)

		local EquipAction = ItsyScape.Action.Equip() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Magic",
				Count = ItsyScape.Utility.xpForLevel(tier.tier)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Wisdom",
				Count = ItsyScape.Utility.xpForLevel(tier.tier)
			}
		}

		local DequipAction = ItsyScape.Action.Dequip()

		local CraftAction = ItsyScape.Action.Craft()
		if tier.tertiary then
			CraftAction {
				Input {
					Resource = ItsyScape.Resource.Item(string.format("%sLogs", tier.wood)),
					Count = itemProps.logs
				},

				Input {
					Resource = ItsyScape.Resource.Item(tier.tertiary),
					Count = itemProps.logs
				},

				Requirement {
					Resource = ItsyScape.Resource.Skill "Crafting",
					Count = ItsyScape.Utility.xpForLevel(math.max(tier.tier + itemProps.logs - 1, 1)),
				},

				Requirement {
					Resource = ItsyScape.Resource.Item "Knife",
					Count = 1,
				},

				Output {
					Resource = ItsyScape.Resource.Skill "Crafting",
					Count = ItsyScape.Utility.xpForResource(math.max(tier.tier + itemProps.logs + 2, 1)) * itemProps.logs
				},

				Output {
					Resource = Item,
					Count = 1
				}
			}
		else
			CraftAction {
				Input {
					Resource = ItsyScape.Resource.Item(string.format("%sLogs", tier.wood)),
					Count = itemProps.logs
				},

				Requirement {
					Resource = ItsyScape.Resource.Skill "Crafting",
					Count = ItsyScape.Utility.xpForLevel(math.max(tier.tier + itemProps.logs - 1, 1)),
				},

				Requirement {
					Resource = ItsyScape.Resource.Item "Knife",
					Count = 1,
				},

				Output {
					Resource = ItsyScape.Resource.Skill "Crafting",
					Count = ItsyScape.Utility.xpForResource(math.max(tier.tier + itemProps.logs + 2, 1)) * itemProps.logs
				},

				Output {
					Resource = Item,
					Count = 1
				}
			}
		end

		ItsyScape.Meta.Item {
			Value = ItsyScape.Utility.valueForItem(tier.tier + itemProps.logs + 2) * itemProps.logs,
			Weight = itemProps.logs * tier.weight,
			Resource = Item
		}

		ItsyScape.Meta.ResourceName {
			Value = string.format(itemProps.niceName, name),
			Language = "en-US",
			Resource = Item
		}

		ItsyScape.Meta.EquipmentModel {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = string.format("Resources/Game/Skins/%s/%s.lua", name, itemName),
			Resource = Item
		}

		ItsyScape.Meta.ResourceCategory {
			Key = "Wood",
			Value = tier.wood,
			Resource = Item
		}

		Item {
			EquipAction,
			DequipAction,
			CraftAction
		}

		ItsyScape.Utility.tag(Item, "magic")
	end
end

-- Dinky (common)
do
	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(4, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(4, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(4),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "DinkyWand"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Probably more useful as firewood.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "DinkyWand"
	}


	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(4, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(5, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(5),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "DinkyCane"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Just what Grandpa needed.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "DinkyCane"
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(5, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(6, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(6),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "DinkyStaff"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Not suitable for epic boss battles.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "DinkyStaff"
	}
end

-- Feeble (willow)
do
	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(14, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(14, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(14),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "FeebleWand"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Too damp for firewood.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "FeebleWand"
	}


	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(14, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(15, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(15),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "FeebleCane"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Not suited for a hunter.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "FeebleCane"
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(15, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(16, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(16),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "FeebleStaff"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Good for the Itsy Commons Fair, not much else.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "FeebleStaff"
	}
end

-- Fungal (Azathothian)
do
	ItsyScape.Meta.Item {
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "BlackTalon"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Black talon",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlackTalon"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A talon from a fierce Eldritch abomination, the Ill-Colored Hawk.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlackTalon"
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(95, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(95, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(100),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "FungalWand"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Don't poke your eye out! You may grow a tentacle in its place.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "FungalWand"
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(100, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(100, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(105),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "FungalCane"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Suited for the finest of hunters.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "FungalCane"
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(100, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(105, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(115),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "FungalStaff"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A staff made for a champion of the most primal horrors.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "FungalStaff"
	}
end

-- Moldy (oak)
do
	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(24, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(24, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(24),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "MoldyWand"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The mold on this wand can't be healthy...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MoldyWand"
	}


	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(24, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(25, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(25),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "MoldyCane"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "An old, moldy cane, not suitable for even your grandpa's evil twin.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MoldyCane"
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(25, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(26, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(26),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "MoldyStaff"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Might make you sneeze while casting a spell.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MoldyStaff"
	}
end

-- Springy (maple)
do
	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(34, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(34, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(34),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "SpringyWand"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Makes spells pop!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SpringyWand"
	}


	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(34, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(35, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(35),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "SpringyCane"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "This wood is not suited for a cane!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SpringyCane"
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(35, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(36, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(36),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "SpringyStaff"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Can use it as a vaulting pole, too.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SpringyStaff"
	}
end

-- Tense (yew)
do
	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(44, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(44, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(44),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "TenseWand"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Gives an extra zap.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "TenseWand"
	}


	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(44, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(45, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(45),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "TenseCane"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A refined cane for a refined individual.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "TenseCane"
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(45, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(46, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(46),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "TenseStaff"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A mystical staff.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "TenseStaff"
	}
end

-- Scary (petrified spider)
do
	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(54, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(54, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(54),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "ScaryWand"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Intimdating.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "ScaryWand"
	}


	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(54, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(55, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(55),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "ScaryCane"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The handle is sticky!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "ScaryCane"
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(55, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(60, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(59),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "ScaryStaff"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A dangerous staff powered by the remains of an ancient spider.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "ScaryStaff"
	}
end
