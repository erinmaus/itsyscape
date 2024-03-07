--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/UpAndComingHero.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "UpAndComingHeroHelmet" {
	ItsyScape.Action.Smith() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Hammer",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "WeirdAlloyBar",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "UpAndComingHeroHelmet",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForResource(1)
		}
	},

	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(1)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.ResourceName {
	Value = "Up-and-coming hero's helmet",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "UpAndComingHeroHelmet"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/UpAndComingHero/Helmet.lua",
	Resource = ItsyScape.Resource.Item "UpAndComingHeroHelmet"
}

ItsyScape.Meta.ResourceCategory {
	Key = "Metal",
	Value = "WeirdAlloy",
	Resource = ItsyScape.Resource.Item "UpAndComingHeroHelmet"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(5),
	Weight = 0,
	Resource = ItsyScape.Resource.Item "UpAndComingHeroHelmet"
}

ItsyScape.Resource.Item "UpAndComingHeroPlatebody" {
	ItsyScape.Action.Smith() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Hammer",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "WeirdAlloyBar",
			Count = 2
		},

		Output {
			Resource = ItsyScape.Resource.Item "UpAndComingHeroPlatebody",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForResource(1) * 2
		}
	},

	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(1)
		}
	},
	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.ResourceName {
	Value = "Up-and-coming hero's platebody",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "UpAndComingHeroPlatebody"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/UpAndComingHero/Body.lua",
	Resource = ItsyScape.Resource.Item "UpAndComingHeroPlatebody"
}

ItsyScape.Meta.ResourceCategory {
	Key = "Metal",
	Value = "WeirdAlloy",
	Resource = ItsyScape.Resource.Item "UpAndComingHeroPlatebody"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(5) * 2,
	Weight = 0,
	Resource = ItsyScape.Resource.Item "UpAndComingHeroPlatebody"
}

ItsyScape.Resource.Item "UpAndComingHeroGloves" {
	ItsyScape.Action.Smith() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Hammer",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "WeirdAlloyBar",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "UpAndComingHeroGloves",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForResource(1)
		}
	},

	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(1)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.ResourceName {
	Value = "Up-and-coming hero's gloves",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "UpAndComingHeroGloves"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/UpAndComingHero/Gloves.lua",
	Resource = ItsyScape.Resource.Item "UpAndComingHeroGloves"
}

ItsyScape.Meta.ResourceCategory {
	Key = "Metal",
	Value = "WeirdAlloy",
	Resource = ItsyScape.Resource.Item "UpAndComingHeroGloves"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(5),
	Weight = 0,
	Resource = ItsyScape.Resource.Item "UpAndComingHeroGloves"
}

ItsyScape.Resource.Item "UpAndComingHeroBoots" {
	ItsyScape.Action.Smith() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Hammer",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "WeirdAlloyBar",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "UpAndComingHeroBoots",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForResource(1)
		}
	},

	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(1)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.ResourceName {
	Value = "Up-and-coming hero's boots",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "UpAndComingHeroBoots"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/UpAndComingHero/Boots.lua",
	Resource = ItsyScape.Resource.Item "UpAndComingHeroBoots"
}

ItsyScape.Meta.ResourceCategory {
	Key = "Metal",
	Value = "WeirdAlloy",
	Resource = ItsyScape.Resource.Item "UpAndComingHeroBoots"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(5),
	Resource = ItsyScape.Resource.Item "UpAndComingHeroBoots"
}

ItsyScape.Meta.Equipment {
	DefenseStab = ItsyScape.Utility.styleBonusForHands(1),
	DefenseCrush = ItsyScape.Utility.styleBonusForHands(1),
	DefenseSlash = ItsyScape.Utility.styleBonusForHands(1),
	DefenseRanged = ItsyScape.Utility.styleBonusForHands(1),
	DefenseMagic = ItsyScape.Utility.styleBonusForHands(1),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
	Resource = ItsyScape.Resource.Item "UpAndComingHeroGloves"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Lightweight gloves that offer a little bit of protection. Better than nothing!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "UpAndComingHeroGloves"
}

ItsyScape.Meta.Equipment {
	DefenseStab = ItsyScape.Utility.styleBonusForFeet(1),
	DefenseCrush = ItsyScape.Utility.styleBonusForFeet(1),
	DefenseSlash = ItsyScape.Utility.styleBonusForFeet(1),
	DefenseRanged = ItsyScape.Utility.styleBonusForFeet(1),
	DefenseMagic = ItsyScape.Utility.styleBonusForFeet(1),
	StrengthMelee = 2,
	StrengthMagic = 2,
	StrengthRanged = 2,
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
	Resource = ItsyScape.Resource.Item "UpAndComingHeroBoots"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Gives you a little extra kick when you fight.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "UpAndComingHeroBoots"
}

ItsyScape.Meta.Equipment {
	DefenseStab = ItsyScape.Utility.styleBonusForHead(1),
	DefenseCrush = ItsyScape.Utility.styleBonusForHead(1),
	DefenseSlash = ItsyScape.Utility.styleBonusForHead(1),
	DefenseRanged = ItsyScape.Utility.styleBonusForHead(1),
	DefenseMagic = ItsyScape.Utility.styleBonusForHead(1),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
	Resource = ItsyScape.Resource.Item "UpAndComingHeroHelmet"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Offers some protection from glancing blows to the head.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "UpAndComingHeroHelmet"
}

ItsyScape.Meta.Equipment {
	DefenseStab = ItsyScape.Utility.styleBonusForBody(2),
	DefenseCrush = ItsyScape.Utility.styleBonusForBody(2),
	DefenseSlash = ItsyScape.Utility.styleBonusForBody(2),
	DefenseRanged = ItsyScape.Utility.styleBonusForBody(2),
	DefenseMagic = ItsyScape.Utility.styleBonusForBody(2),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
	Resource = ItsyScape.Resource.Item "UpAndComingHeroPlatebody"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Made from a weird, light-weight copper-azatite alloy. Provides minimal defence against direct blows.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "UpAndComingHeroPlatebody"
}
