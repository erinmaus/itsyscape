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
		health = 8,
		hammer = "Hammer"
	},

	["Iron"] = {
		tier = 10,
		weight = 14.5,
		hammer = "Hammer"
	},

	["Adamant"] = {
		tier = 40,
		weight = 25,
		hammer = "Hammer"
	},

	["Itsy"] = {
		tier = 50,
		weight = 5,
		hammer = "Hammer"
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
			Resource = Item,
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForResource(math.max(metal.tier + 2, 1))
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
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(metal.tier),
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

	ItsyScape.Utility.tag(Item, "tool")
	ItsyScape.Utility.tag(Item, "melee")
end

ItsyScape.Meta.ResourceDescription {
	Value = "Helps you mine.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "BronzePickaxe"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Helps you mine a little bit better.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IronPickaxe"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Smashes rocks.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AdamantPickaxe"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Crushes ore like a boot crushes bugs.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ItsyPickaxe"
}
