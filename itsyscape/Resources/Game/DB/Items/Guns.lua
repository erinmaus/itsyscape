--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Bullets.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local METALS = {
	["Iron"] = {
		tier = 10,
		weight = 17.5,
		wood = "WillowLogs"
	},

	["BlackenedIron"] = {
		niceName = "Blackened iron",
		tier = 20,
		weight = 15,
		wood = "OakLogs"
	},

	["Mithril"] = {
		tier = 30,
		weight = 3.7,
		wood = "MapleLogs"
	},

	["Adamant"] = {
		tier = 40,
		weight = 22,
		wood = "YewLogs"
	},

	["Itsy"] = {
		tier = 50,
		weight = 19.5,
		wood = "PetrifiedSpiderLogs"
	}
}

local GUNS = {
	["Blunderbuss"] = {
		niceName = "blunderbuss",
		bars = 3,
		logs = 1
	},

	["Musket"] = {
		niceName = "musket",
		bars = 2,
		logs = 1
	},

	["Pistol"] = {
		niceName = "flintlock pistol",
		bars = 1,
		logs = 1
	}
}

for gunName, gun in spairs(GUNS) do
	for metalName, metal in spairs(METALS) do
		local ItemName = string.format("%s%s", metalName, gunName)
		local Item = ItsyScape.Resource.Item(ItemName)

		local EquipAction = ItsyScape.Action.Equip() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Archery",
				Count = ItsyScape.Utility.xpForLevel(metal.tier)
			},


			Requirement {
				Resource = ItsyScape.Resource.Skill "Dexterity",
				Count = ItsyScape.Utility.xpForLevel(metal.tier)
			}
		}

		local DequipAction = ItsyScape.Action.Dequip()

		local SmithAction = ItsyScape.Action.Smith() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Engineering",
				Count = ItsyScape.Utility.xpForLevel(metal.tier + gun.bars)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForLevel(metal.tier + gun.bars)
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "Hammer",
				Count = 1
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "Knife",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "BlackFlint",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item(metal.wood),
				Count = gun.logs
			},

			Input {
				Resource = ItsyScape.Resource.Item(string.format("%sBar", metalName)),
				Count = gun.bars
			},

			Output {
				Resource = Item,
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Engineering",
				Count = ItsyScape.Utility.xpForResource(metal.tier + 1 + gun.bars) * (gun.logs + gun.bars)
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForResource(metal.tier + 1 + gun.bars) * (gun.logs + gun.bars)
			}
		}

		ItsyScape.Meta.Item {
			Value = ItsyScape.Utility.valueForItem(metal.tier + 2 + gun.bars) * (gun.logs + gun.bars),
			Weight = metal.weight,
			Resource = Item
		}

		ItsyScape.Meta.ResourceCategory {
			Key = "Metal",
			Value = metalName,
			Resource = Item
		}

		ItsyScape.Meta.ResourceCategory {
			Key = "Gun",
			Value = metalName,
			Resource = Item
		}

		ItsyScape.Meta.ResourceName {
			Value = string.format("%s %s", metal.niceName or metalName, gun.niceName),
			Language = "en-US",
			Resource = Item
		}

		ItsyScape.Meta.EquipmentModel {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = string.format("Resources/Game/Skins/%s/%s.lua", metalName, gunName),
			Resource = Item
		}

		Item {
			EquipAction,
			DequipAction,
			SmithAction
		}

		ItsyScape.Utility.tag(Item, "archery")
	end
end

-- Iron
do
	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(10, 1),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(15, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "IronBlunderbuss"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "That will hurt up close, but not from afar.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IronBlunderbuss"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(15, 1),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(10, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "IronMusket"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Wide shot!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IronMusket"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(10, 1.2),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(10, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "IronPistol"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Don't want to be on the recieving end of that.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IronPistol"
	}
end

-- Blackened iron
do
	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(20, 1),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(25, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "BlackenedIronBlunderbuss"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A fierce looking blunderbuss.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlackenedIronBlunderbuss"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(25, 1),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(20, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "BlackenedIronMusket"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Shoots in a cone of terror!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlackenedIronMusket"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(20, 1.2),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(20, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "BlackenedIronPistol"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Small and convenient! Packs a punch.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlackenedIronPistol"
	}
end

-- Mithril
do
	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(30, 1),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(35, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "MithrilBlunderbuss"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "This blunderbuss is a lot lighter than it looks.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MithrilBlunderbuss"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(35, 1),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(30, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "MithrilMusket"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Light, but the recoil is pretty hefty.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MithrilMusket"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(30, 1.2),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(30, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "MithrilPistol"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "So light you may forget you're carrying it...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MithrilPistol"
	}
end

-- Adamant
do
	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(40, 1),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(45, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "AdamantBlunderbuss"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Very well built blunderbuss. Don't have to worry about it 'sploding in your face!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AdamantBlunderbuss"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(45, 1),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(40, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "AdamantMusket"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Monstrous recoil, be prepared!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AdamantMusket"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(40, 1.2),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(40, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "AdamantPistol"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A fine pistol for a fine person.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AdamantPistol"
	}
end

-- Itsy
do
	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(50, 1),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(55, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "ItsyBlunderbuss"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The petrified spider stock feels gross, but it helps absorb the shot!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "ItsyBlunderbuss"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(55, 1),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(50, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "ItsyMusket"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A fine weapon: little recoil and much power.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "ItsyMusket"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(50, 1.2),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(50, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "ItsyPistol"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A fine choice for duels.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "ItsyPistol"
	}
end
