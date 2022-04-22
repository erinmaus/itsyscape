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
		tier = 10
	}
}

for name, metal in pairs(METALS) do
	local ItemName = string.format("%sBullet", name)
	local Item = ItsyScape.Resource.Item(ItemName)

	local EquipAction = ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForLevel(metal.tier)
		}
	}

	local DequipAction = ItsyScape.Action.Dequip()

	local SmithAction = ItsyScape.Action.Smith() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Engineering",
			Count = ItsyScape.Utility.xpForLevel(metal.tier)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForLevel(metal.tier)
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Hammer",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "Gunpowder",
			Count = 5
		},

		Input {
			Resource = ItsyScape.Resource.Item(string.format("%sBar", name)),
			Count = 1
		},

		Output {
			Resource = Item,
			Count = 10
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Engineering",
			Count = ItsyScape.Utility.xpForResource(metal.tier + 1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForResource(metal.tier + 1)
		}
	}

	ItsyScape.Meta.Item {
		Value = math.min(math.floor(ItsyScape.Utility.valueForItem(metal.tier + 2) / 10), 10) * metal.tier,
		Weight = 0,
		Stackable = 1,
		Resource = Item
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = name,
		Resource = Item
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Bullet",
		Value = name,
		Resource = Item
	}

	ItsyScape.Meta.RangedAmmo {
		Type = ItsyScape.Utility.Equipment.AMMO_BULLET,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = string.format("%s bullet", name),
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Equipment {
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(metal.tier + 10),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_QUIVER,
		Resource = Item
	}

	Item {
		EquipAction,
		DequipAction,
		SmithAction
	}

	ItsyScape.Utility.tag(Item, "archery")
end

ItsyScape.Meta.ResourceDescription {
	Value = "That's gonna hurt!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IronBullet"
}
