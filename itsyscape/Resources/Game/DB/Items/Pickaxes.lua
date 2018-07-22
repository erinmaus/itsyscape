--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Pickaxes.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local METALS = {
	["Bronze"] = {
		tier = 1,
		weight = 12.5,
		health = 8
	}
}

for name, metal in pairs(METALS) do
	local ItemName = string.format("%sPickaxe", name)
	local Item = ItsyScape.Resource.Item(ItemName)

	local EquipAction = ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForLevel(metal.tier)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForLevel(metal.tier)
		}
	}

	local DequipAction = ItsyScape.Action.Dequip()

	local SmithAction = ItsyScape.Action.Smith()
	SmithAction {
		Input {
			Resource = ItsyScape.Resource.Item(string.format("%sBar", metal)),
			Count = 1
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForLevel(math.max(metal.tier, 1))
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForResource(math.max(metal.tier + 2, 1))
		},

		Output {
			Resource = Item,
			Count = 1
		}
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(metal.tier + 2),
		Weight = metal.weight,
		Resource = Item
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = name,
		Resource = Item
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "WeaponType",
		Value = "pickaxe",
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = string.format("%s pickaxe", name),
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab  = ItsyScape.Utility.styleBonusForWeapon(metal.tier),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(metal.tier),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = Item
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = string.format("Resources/Game/Skins/%s/Pickaxe.lua", name),
		Resource = Item
	}

	Item {
		EquipAction,
		DequipAction,
		SmithAction
	}
end
