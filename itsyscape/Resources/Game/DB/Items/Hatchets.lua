--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Hatchet.lua
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
		health = 8,
		hammer = "Hammer"
	}
}

for name, metal in pairs(METALS) do
	local ItemName = string.format("%sHatchet", name)
	local Item = ItsyScape.Resource.Item(ItemName)

	local EquipAction = ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Woodcutting",
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
			Resource = ItsyScape.Resource.Item(string.format("%sBar", name)),
			Count = 1
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForLevel(math.max(metal.tier, 1))
		},

		Requirement {
			Resource = ItsyScape.Resource.Item(metal.hammer),
			Count = 1
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
		Value = "hatchet",
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = string.format("%s hatchet", name),
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash  = ItsyScape.Utility.styleBonusForWeapon(metal.tier + 1),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(metal.tier + 2),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = Item
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = string.format("Resources/Game/Skins/%s/Hatchet.lua", name),
		Resource = Item
	}

	Item {
		EquipAction,
		DequipAction,
		SmithAction
	}
end

ItsyScape.Meta.ResourceDescription {
	Value = "Here's...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "BronzeHatchet"
}

-- ...Nny! (Iron)
-- Lizzie Borden had an axe... (Steel)
-- ...gave her mother forty whacks... (Mithril)
-- ...when she had seen what she had done... (Adamant)
-- ...she gave her father forty-one. (Itsy)
