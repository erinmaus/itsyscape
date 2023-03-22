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
		bulletCount = 15,
		grenadeCount = 10
	},

	["BlackenedIron"] = {
		niceName = "Blackened iron",
		tier = 20,
		bulletCount = 20,
		grenadeCount = 15
	},

	["Mithril"] = {
		tier = 30,
		bulletCount = 25,
		grenadeCount = 20
	},

	["Adamant"] = {
		tier = 40,
		bulletCount = 30,
		grenadeCount = 25
	},

	["Itsy"] = {
		tier = 50,
		bulletCount = 35,
		grenadeCount = 30
	}
}

for name, metal in spairs(METALS) do
	local ItemName = string.format("%sBullet", name)
	local Item = ItsyScape.Resource.Item(ItemName)
	local GrenadeItemName = string.format("%sGrenade", name)
	local GrenadeItem = ItsyScape.Resource.Item(GrenadeItemName)

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
			Count = math.max(math.floor(metal.bulletCount / 2), 1)
		},

		Input {
			Resource = ItsyScape.Resource.Item(string.format("%sBar", name)),
			Count = 1
		},

		Output {
			Resource = Item,
			Count = metal.bulletCount
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

	local GrenadeSmithAction = ItsyScape.Action.Smith() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Engineering",
			Count = ItsyScape.Utility.xpForLevel(metal.tier + 10)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForLevel(metal.tier + 10)
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Hammer",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "Gunpowder",
			Count = math.max(math.floor(metal.grenadeCount / 2), 1)
		},

		Input {
			Resource = ItsyScape.Resource.Item(string.format("%sBar", name)),
			Count = 1
		},

		Output {
			Resource = GrenadeItem,
			Count = metal.grenadeCount
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Engineering",
			Count = ItsyScape.Utility.xpForResource(metal.tier + 11)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForResource(metal.tier + 11)
		}
	}

	ItsyScape.Meta.Item {
		Value = math.min(math.floor(ItsyScape.Utility.valueForItem(metal.tier + 12) / 10), 10) * metal.tier,
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
		Value = string.format("%s bullet", metal.niceName or name),
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Equipment {
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(metal.tier + 10),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_QUIVER,
		Resource = Item
	}

	ItsyScape.Meta.Item {
		Value = math.min(math.floor(ItsyScape.Utility.valueForItem(metal.tier + 12) / 10), 10) * metal.tier,
		Weight = 0,
		Stackable = 1,
		Resource = GrenadeItem
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = name,
		Resource = GrenadeItem
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Bullet",
		Value = name,
		Resource = GrenadeItem
	}

	ItsyScape.Meta.RangedAmmo {
		Type = ItsyScape.Utility.Equipment.AMMO_THROWN,
		Resource = GrenadeItem
	}

	ItsyScape.Meta.ResourceName {
		Value = string.format("%s grenade", metal.niceName or name),
		Language = "en-US",
		Resource = GrenadeItem
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = string.format("Resources/Game/Skins/%s/Grenade.lua", name),
		Resource = GrenadeItem
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(metal.tier + 10),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(metal.tier + 15),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = GrenadeItem
	}

	Item {
		EquipAction,
		DequipAction,
		SmithAction
	}

	GrenadeItem {
		EquipAction,
		DequipAction,
		GrenadeSmithAction
	}

	ItsyScape.Utility.tag(Item, "archery")
	ItsyScape.Utility.tag(GrenadeItem, "archery")
end

ItsyScape.Meta.ResourceDescription {
	Value = "That's gonna hurt!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IronBullet"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Don't wanna drop this at your feet.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IronGrenade"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A bullet for my valentine.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "BlackenedIronBullet"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Watch out! The shrapnel from this grenade hurts!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "BlackenedIronGrenade"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Pierces weaker armors like butter.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "BlackenedIronBullet"
}

ItsyScape.Meta.ResourceDescription {
	Value = "This shrapnel is so light it ricochets off everything.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "BlackenedIronGrenade"
}
