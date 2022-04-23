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
	}
}

for gunName, gun in pairs(GUNS) do
	for metalName, metal in pairs(METALS) do
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
			Value = string.format("%s %s", metalName, gun.niceName),
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

do
	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(10, 1),
		StrengthRanged = ItsyScape.Utility.styleBonusForWeapon(15, 1),
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
		StrengthRanged = ItsyScape.Utility.styleBonusForWeapon(10, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "IronMusket"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Wide shot!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IronMusket"
	}
end
