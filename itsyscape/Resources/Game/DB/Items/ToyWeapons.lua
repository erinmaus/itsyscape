--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/ToyWeapons.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Item = ItsyScape.Resource.Item "ToyLongsword"

	local EquipAction = ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(1)
		}
	}

	local DequipAction = ItsyScape.Action.Dequip()

	local CraftAction = ItsyScape.Action.Craft() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Knife",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "ShadowLogs",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForResource(2) * 2
		},

		Output {
			Resource = Item,
			Count = 1
		}
	}

	ItsyScape.Meta.Item {
		Value = 1,
		Weight = 1.6,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = "Toy longsword",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Good for sparring practice if you're a child.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "ToyLongsword"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Wood",
		Value = "Shadow",
		Resource = Item
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/Toy/Longsword.lua",
		Resource = Item
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(1, 1),
		StrengthMelee = ItsyScape.Utility.styleBonusForWeapon(2, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "ToyLongsword"
	}

	Item {
		EquipAction,
		DequipAction,
		CraftAction
	}
end

do
	local Item = ItsyScape.Resource.Item "ToyWand"

	local EquipAction = ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(1)
		}
	}

	local DequipAction = ItsyScape.Action.Dequip()

	local CraftAction = ItsyScape.Action.Craft() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Knife",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "ShadowLogs",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForResource(2) * 2
		},

		Output {
			Resource = Item,
			Count = 1
		}
	}

	ItsyScape.Meta.Item {
		Value = 1,
		Weight = 1.6,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = "Toy wand",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "With enough imagination, even a twig can be a weapon.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "ToyWand"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Wood",
		Value = "Shadow",
		Resource = Item
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/Toy/Wand.lua",
		Resource = Item
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(1, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(1, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.styleBonusForWeapon(1, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "ToyWand"
	}

	Item {
		EquipAction,
		DequipAction,
		CraftAction
	}
end

do
	local Item = ItsyScape.Resource.Item "ToyBoomerang"

	local EquipAction = ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForLevel(1)
		}
	}

	local DequipAction = ItsyScape.Action.Dequip()

	local FletchAction = ItsyScape.Action.Fletch() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Engineering",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Knife",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "ShadowLogs",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Engineering",
			Count = ItsyScape.Utility.xpForResource(2) * 2
		},

		Output {
			Resource = Item,
			Count = 1
		}
	}

	ItsyScape.Meta.Item {
		Value = 1,
		Weight = 1.6,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = "Toy boomerang",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Still hurts, just not much.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "ToyBoomerang"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Wood",
		Value = "Shadow",
		Resource = Item
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/Toy/Boomerang.lua",
		Resource = Item
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(1, 1),
		StrengthRanged = ItsyScape.Utility.styleBonusForWeapon(1, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "ToyBoomerang"
	}

	Item {
		EquipAction,
		DequipAction,
		FletchAction
	}
end

