--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Bows.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local LOGS = {
	["Common"] = {
		tier = 1,
		weight = 8,
		style = "Puny",
		bowstring = "Bowstring"
	},

	["Willow"] = {
		tier = 10,
		weight = 6,
		style = "Bendy",
		bowstring = "Bowstring"
	}
}

local ITEMS = {
	["Boomerang"] = {
		tier = 1,
		niceName = "%s boomerang",
		isBoomerang = true
	},

	["Bow"] = {
		tier = 3,
		niceName = "%s bow"
	},

	["Longbow"] = {
		tier = 6, 
		niceName = "%s longbow"
	}
}


for name, log in pairs(LOGS) do
	for itemName, itemProps in pairs(ITEMS) do
		local ItemName = string.format("%s%s", log.style, itemName)
		local Item = ItsyScape.Resource.Item(ItemName)

		local EquipAction = ItsyScape.Action.Equip() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Archery",
				Count = ItsyScape.Utility.xpForLevel(log.tier)
			}
		}

		local DequipAction = ItsyScape.Action.Dequip()

		local FletchAction = ItsyScape.Action.Fletch() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Engineering",
				Count = ItsyScape.Utility.xpForLevel(math.max(log.tier + itemProps.tier - 1, 1))
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "Knife",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item(string.format("%sLogs", name)),
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Engineering",
				Count = ItsyScape.Utility.xpForResource(log.tier + itemProps.tier) * 2
			},

			Output {
				Resource = Item,
				Count = 1
			}
		}

		if not itemProps.isBoomerang then
			FletchAction {
				Input {
					Resource = ItsyScape.Resource.Item(log.bowstring),
					Count = 1
				}
			}
		end

		ItsyScape.Meta.Item {
			Value = ItsyScape.Utility.valueForItem(log.tier + itemProps.tier),
			Weight = log.weight,
			Resource = Item
		}

		ItsyScape.Meta.ResourceName {
			Value = string.format(itemProps.niceName, log.style),
			Language = "en-US",
			Resource = Item
		}

		ItsyScape.Meta.ResourceCategory {
			Key = "Wood",
			Value = name,
			Resource = Item
		}

		ItsyScape.Utility.tag(Item, "archery")

		ItsyScape.Meta.EquipmentModel {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = string.format("Resources/Game/Skins/%s/%s.lua", log.style, itemName),
			Resource = Item
		}

		Item {
			EquipAction,
			DequipAction,
			FletchAction
		}
	end
end

-- Bowstrings
do
	ItsyScape.Resource.Item "Bowstring" {
		ItsyScape.Action.Craft() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Flax",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "Bowstring",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForResource(3)
			}
		}
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Fiber",
		Value = "Flax",
		Resource = ItsyScape.Resource.Item "Bowstring"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(2),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "Bowstring"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Bowstring",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Bowstring"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Twang!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Bowstring"
	}
end

-- Common/bronze
do
	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(4, 1),
		StrengthRanged = ItsyScape.Utility.styleBonusForWeapon(3, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "PunyBoomerang"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Bringin' it around town, bringin' it around town...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PunyBoomerang"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(5, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "PunyBow"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A weak bow; quick to fire, but low range.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PunyBow"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(10, 1),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(5, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "PunyLongbow"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A weak longbow; slow to fire, but awesome range.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PunyLongbow"
	}
end

-- Willow/iron
do
	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(14, 1),
		StrengthRanged = ItsyScape.Utility.styleBonusForWeapon(13, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "BendyBoomerang"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A small breeze will snap it.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BendyBoomerang"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(15, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "BendyBow"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Extra bendy, but short range.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BendyBow"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(20, 1),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(15, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "BendyLongbow"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Good range, but low arrow-power.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BendyLongbow"
	}
end
