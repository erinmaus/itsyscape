--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Amulets.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	ItsyScape.Resource.Item "CopperAmulet" {
		ItsyScape.Action.Equip(),
		ItsyScape.Action.Dequip(),
		ItsyScape.Action.Smith() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "Hammer",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "CopperBar",
				Count = 1
			},
			
			Output {
				Resource = ItsyScape.Resource.Item "CopperAmulet",
				Count = 1
			},
			
			Output {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForResource(2)
			},
			
			Output {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForResource(2)
			}
		}
	}

	ItsyScape.Meta.Equipment {
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_NECK,
		Resource = ItsyScape.Resource.Item "CopperAmulet"
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/Amulets/Copper.lua",
		Resource = ItsyScape.Resource.Item "CopperAmulet"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(3) * 2,
		Weight = 0,
		Resource = ItsyScape.Resource.Item "CopperAmulet"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Copper amulet",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CopperAmulet"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Currently a fashionable trinket.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CopperAmulet"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = "Copper",
		Resource = ItsyScape.Resource.Item "CopperAmulet"
	}
end

do
	ItsyScape.Resource.Item "GhostspeakAmulet" {
		ItsyScape.Action.Equip(),
		ItsyScape.Action.Dequip(),
		ItsyScape.Action.Enchant() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Magic",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Input {
				Resource = ItsyScape.Resource.Item "CosmicRune",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "AirRune",
				Count = 1
			},
			
			Input {
				Resource = ItsyScape.Resource.Item "CopperAmulet",
				Count = 1
			},
			
			Output {
				Resource = ItsyScape.Resource.Item "GhostspeakAmulet",
				Count = 1
			},
			
			Output {
				Resource = ItsyScape.Resource.Skill "Magic",
				Count = ItsyScape.Utility.xpForResource(2)
			}
		}
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = -1,
		AccuracySlash = -1,
		AccuracyCrush = -1,
		AccuracyMagic = -1,
		AccuracyRanged = -1,
		DefenseStab = -1,
		DefenseSlash = -1,
		DefenseCrush = -1,
		DefenseMagic = -1,
		DefenseRanged = -1,
		StrengthMelee = -1,
		StrengthRanged = -1,
		StrengthMagic = -1,
		Prayer = 4,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_NECK,
		Resource = ItsyScape.Resource.Item "GhostspeakAmulet"
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/Amulets/Ghostspeak.lua",
		Resource = ItsyScape.Resource.Item "GhostspeakAmulet"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(30),
		Weight = -1,
		Resource = ItsyScape.Resource.Item "GhostspeakAmulet"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Ghostspeak amulet",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "GhostspeakAmulet"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Makes them ecto-spookies less spooky.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "GhostspeakAmulet"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Enchanted",
		Value = "Copper",
		Resource = ItsyScape.Resource.Item "GhostspeakAmulet"
	}
end

do
	ItsyScape.Resource.Item "GoldenAmulet" {
		ItsyScape.Action.Equip(),
		ItsyScape.Action.Dequip(),
		ItsyScape.Action.Smith() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForLevel(60)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(60)
			},

			Input {
				Resource = ItsyScape.Resource.Item "GoldBar",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "GoldenAmulet",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForResource(60)
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForResource(60)
			},
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Golden amulet",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "GoldenAmulet"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = "Gold",
		Resource = ItsyScape.Resource.Item "GoldenAmulet"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(60),
		Resource = ItsyScape.Resource.Item "GoldenAmulet"
	}

	ItsyScape.Resource.Item "GoldenAmulet" {
		ItsyScape.Action.Equip(),
		ItsyScape.Action.Dequip()
	}

	ItsyScape.Meta.Equipment {
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(2) / 3,
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(2) / 3,
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(2) / 3,
		Prayer = 15,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_NECK,
		Resource = ItsyScape.Resource.Item "GoldenAmulet"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "So pretty! Maybe if it were enchanted, it could be more useful...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "GoldenAmulet"
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/Amulets/Golden.lua",
		Resource = ItsyScape.Resource.Item "GoldenAmulet"
	}
end

do
	ItsyScape.Resource.Item "CopperRing" {
		ItsyScape.Action.Equip(),
		ItsyScape.Action.Dequip(),
		ItsyScape.Action.Smith() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "Hammer",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "CopperBar",
				Count = 1
			},
			
			Output {
				Resource = ItsyScape.Resource.Item "CopperRing",
				Count = 1
			},
			
			Output {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForResource(2)
			},
			
			Output {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForResource(2)
			}
		}
	}

	ItsyScape.Meta.Equipment {
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FINGER,
		Resource = ItsyScape.Resource.Item "CopperRing"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(3) * 2,
		Weight = 0,
		Resource = ItsyScape.Resource.Item "CopperRing"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Copper ring",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CopperRing"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Not worth much, but it has the potential for so much more.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CopperRing"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = "Copper",
		Resource = ItsyScape.Resource.Item "CopperRing"
	}
end

do
	ItsyScape.Resource.Item "GhostBindersRing" {
		ItsyScape.Action.Equip(),
		ItsyScape.Action.Dequip(),
		ItsyScape.Action.Enchant() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Magic",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Input {
				Resource = ItsyScape.Resource.Item "CosmicRune",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "AirRune",
				Count = 1
			},
			
			Input {
				Resource = ItsyScape.Resource.Item "CopperRing",
				Count = 1
			},
			
			Output {
				Resource = ItsyScape.Resource.Item "GhostBindersRing",
				Count = 1
			},
			
			Output {
				Resource = ItsyScape.Resource.Skill "Magic",
				Count = ItsyScape.Utility.xpForResource(2)
			}
		}
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = 2,
		AccuracySlash = 2,
		AccuracyCrush = 2,
		AccuracyMagic = 2,
		AccuracyRanged = 2,
		DefenseStab = 2,
		DefenseSlash = 2,
		DefenseCrush = 2,
		DefenseMagic = 2,
		DefenseRanged = 2,
		StrengthMelee = 2,
		StrengthRanged = 2,
		StrengthMagic = 2,
		Prayer = 4,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FINGER,
		Resource = ItsyScape.Resource.Item "GhostBindersRing"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(28),
		Weight = -1,
		Resource = ItsyScape.Resource.Item "GhostBindersRing"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Ghost binder's ring",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "GhostBindersRing"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Turns damaging attacks from undead and ghosts into healing.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "GhostBindersRing"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Enchanted",
		Value = "Copper",
		Resource = ItsyScape.Resource.Item "GhostBindersRing"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Ghost binder's ring",
		Language = "en-US",
		Resource = ItsyScape.Resource.Effect "GhostBindersRing"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Has a 25% chance of turning damage dealt by ghosts and undead into healing.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Effect "GhostBindersRing"
	}
end
