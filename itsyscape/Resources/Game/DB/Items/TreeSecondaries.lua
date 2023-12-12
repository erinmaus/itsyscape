--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/TreeSecondaries.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "CommonBlackSpider" {
	ItsyScape.Action.ObtainSecondary() {
		Requirement {
			Count = ItsyScape.Utility.xpForLevel(5),
			Resource = ItsyScape.Resource.Skill "Woodcutting"
		},

		Requirement {
			Count = ItsyScape.Utility.xpForLevel(5),
			Resource = ItsyScape.Resource.Skill "Foraging"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(5),
			Resource = ItsyScape.Resource.Skill "Woodcutting"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(5),
			Resource = ItsyScape.Resource.Skill "Foraging"
		},

		Output {
			Count = 1,
			Resource = ItsyScape.Resource.Item "CommonBlackSpider"
		}
	}
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Common black spider",
	Resource = ItsyScape.Resource.Item "CommonBlackSpider"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Evolved to look like a black widow, but it is missing the red hourglass...",
	Resource = ItsyScape.Resource.Item "CommonBlackSpider"
}

ItsyScape.Meta.Item {
	Stackable = 1,
	Value = ItsyScape.Utility.valueForItem(5),
	Resource = ItsyScape.Resource.Item "CommonBlackSpider"
}

ItsyScape.Meta.SecondaryWeight {
	Weight = 250,
	Resource = ItsyScape.Resource.Item "CommonBlackSpider"
}

ItsyScape.Resource.Item "CommonTreeMoth" {
	ItsyScape.Action.ObtainSecondary() {
		Requirement {
			Count = ItsyScape.Utility.xpForLevel(10),
			Resource = ItsyScape.Resource.Skill "Woodcutting"
		},

		Requirement {
			Count = ItsyScape.Utility.xpForLevel(10),
			Resource = ItsyScape.Resource.Skill "Foraging"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(10),
			Resource = ItsyScape.Resource.Skill "Woodcutting"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(10),
			Resource = ItsyScape.Resource.Skill "Foraging"
		},

		Output {
			Count = 1,
			Resource = ItsyScape.Resource.Item "CommonTreeMoth"
		}
	}
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Common tree moth",
	Resource = ItsyScape.Resource.Item "CommonTreeMoth"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "A small moth that lives in all kinds of trees.",
	Resource = ItsyScape.Resource.Item "CommonTreeMoth"
}

ItsyScape.Meta.Item {
	Stackable = 1,
	Value = ItsyScape.Utility.valueForItem(10),
	Resource = ItsyScape.Resource.Item "CommonTreeMoth"
}

ItsyScape.Meta.SecondaryWeight {
	Weight = 250,
	Resource = ItsyScape.Resource.Item "CommonTreeMoth"
}

ItsyScape.Resource.Item "CommonTreeBeetle" {
	ItsyScape.Action.ObtainSecondary() {
		Requirement {
			Count = ItsyScape.Utility.xpForLevel(15),
			Resource = ItsyScape.Resource.Skill "Woodcutting"
		},

		Requirement {
			Count = ItsyScape.Utility.xpForLevel(15),
			Resource = ItsyScape.Resource.Skill "Foraging"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(15),
			Resource = ItsyScape.Resource.Skill "Woodcutting"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(15),
			Resource = ItsyScape.Resource.Skill "Foraging"
		},

		Output {
			Count = 1,
			Resource = ItsyScape.Resource.Item "CommonTreeBeetle"
		}
	}
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Common tree beetle",
	Resource = ItsyScape.Resource.Item "CommonTreeBeetle"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "A colorful beetle that lives in trees.",
	Resource = ItsyScape.Resource.Item "CommonTreeBeetle"
}

ItsyScape.Meta.Item {
	Stackable = 1,
	Value = ItsyScape.Utility.valueForItem(15),
	Resource = ItsyScape.Resource.Item "CommonTreeBeetle"
}

ItsyScape.Meta.SecondaryWeight {
	Weight = 200,
	Resource = ItsyScape.Resource.Item "CommonTreeBeetle"
}

ItsyScape.Resource.Item "RobinEgg" {
	ItsyScape.Action.ObtainSecondary() {
		Requirement {
			Count = ItsyScape.Utility.xpForLevel(1),
			Resource = ItsyScape.Resource.Skill "Woodcutting"
		},

		Requirement {
			Count = ItsyScape.Utility.xpForLevel(1),
			Resource = ItsyScape.Resource.Skill "Foraging"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(1),
			Resource = ItsyScape.Resource.Skill "Woodcutting"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(1),
			Resource = ItsyScape.Resource.Skill "Foraging"
		},

		Output {
			Count = 1,
			Resource = ItsyScape.Resource.Item "RobinEgg"
		}
	}
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Robin egg",
	Resource = ItsyScape.Resource.Item "RobinEgg"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "A pretty blue robin egg.",
	Resource = ItsyScape.Resource.Item "RobinEgg"
}

ItsyScape.Meta.Item {
	Stackable = 1,
	Value = ItsyScape.Utility.valueForItem(1),
	Resource = ItsyScape.Resource.Item "RobinEgg"
}

ItsyScape.Meta.SecondaryWeight {
	Weight = 100,
	Resource = ItsyScape.Resource.Item "RobinEgg"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "RobinEgg",
	Ingredient = ItsyScape.Resource.Ingredient "Egg"
}

ItsyScape.Meta.ItemUserdata {
	Item = ItsyScape.Resource.Item "RobinEgg",
	Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
}

ItsyScape.Meta.ItemValueUserdata {
	Resource = ItsyScape.Resource.Item "RobinEgg",
	Value = ItsyScape.Utility.valueForItem(1)
}

ItsyScape.Meta.ItemUserdata {
	Item = ItsyScape.Resource.Item "RobinEgg",
	Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
}

ItsyScape.Meta.ItemHealingUserdata {
	Hitpoints = 1,
	Resource = ItsyScape.Resource.Item "RobinEgg"
}

ItsyScape.Resource.Item "CardinalEgg" {
	ItsyScape.Action.ObtainSecondary() {
		Requirement {
			Count = ItsyScape.Utility.xpForLevel(5),
			Resource = ItsyScape.Resource.Skill "Woodcutting"
		},

		Requirement {
			Count = ItsyScape.Utility.xpForLevel(5),
			Resource = ItsyScape.Resource.Skill "Foraging"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(5),
			Resource = ItsyScape.Resource.Skill "Woodcutting"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(5),
			Resource = ItsyScape.Resource.Skill "Foraging"
		},

		Output {
			Count = 1,
			Resource = ItsyScape.Resource.Item "CardinalEgg"
		}
	}
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Cardinal egg",
	Resource = ItsyScape.Resource.Item "CardinalEgg"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "A pretty cardinal egg.",
	Resource = ItsyScape.Resource.Item "CardinalEgg"
}

ItsyScape.Meta.Item {
	Stackable = 1,
	Value = ItsyScape.Utility.valueForItem(5),
	Resource = ItsyScape.Resource.Item "CardinalEgg"
}

ItsyScape.Meta.SecondaryWeight {
	Weight = 100,
	Resource = ItsyScape.Resource.Item "CardinalEgg"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "CardinalEgg",
	Ingredient = ItsyScape.Resource.Ingredient "Egg"
}

ItsyScape.Meta.ItemUserdata {
	Item = ItsyScape.Resource.Item "CardinalEgg",
	Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
}

ItsyScape.Meta.ItemValueUserdata {
	Resource = ItsyScape.Resource.Item "CardinalEgg",
	Value = ItsyScape.Utility.valueForItem(5)
}

ItsyScape.Meta.ItemUserdata {
	Item = ItsyScape.Resource.Item "CardinalEgg",
	Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
}

ItsyScape.Meta.ItemHealingUserdata {
	Hitpoints = 2,
	Resource = ItsyScape.Resource.Item "CardinalEgg"
}

ItsyScape.Resource.Item "BlueJayEgg" {
	ItsyScape.Action.ObtainSecondary() {
		Requirement {
			Count = ItsyScape.Utility.xpForLevel(15),
			Resource = ItsyScape.Resource.Skill "Woodcutting"
		},

		Requirement {
			Count = ItsyScape.Utility.xpForLevel(15),
			Resource = ItsyScape.Resource.Skill "Foraging"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(15),
			Resource = ItsyScape.Resource.Skill "Woodcutting"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(15),
			Resource = ItsyScape.Resource.Skill "Foraging"
		},

		Output {
			Count = 1,
			Resource = ItsyScape.Resource.Item "BlueJayEgg"
		}
	}
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Blue jay egg",
	Resource = ItsyScape.Resource.Item "BlueJayEgg"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "A pretty blue jay egg.",
	Resource = ItsyScape.Resource.Item "BlueJayEgg"
}

ItsyScape.Meta.Item {
	Stackable = 1,
	Value = ItsyScape.Utility.valueForItem(15),
	Resource = ItsyScape.Resource.Item "BlueJayEgg"
}

ItsyScape.Meta.SecondaryWeight {
	Weight = 100,
	Resource = ItsyScape.Resource.Item "BlueJayEgg"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "BlueJayEgg",
	Ingredient = ItsyScape.Resource.Ingredient "Egg"
}

ItsyScape.Meta.ItemUserdata {
	Item = ItsyScape.Resource.Item "BlueJayEgg",
	Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
}

ItsyScape.Meta.ItemValueUserdata {
	Resource = ItsyScape.Resource.Item "BlueJayEgg",
	Value = ItsyScape.Utility.valueForItem(15)
}

ItsyScape.Meta.ItemUserdata {
	Item = ItsyScape.Resource.Item "BlueJayEgg",
	Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
}

ItsyScape.Meta.ItemHealingUserdata {
	Hitpoints = 2,
	Resource = ItsyScape.Resource.Item "BlueJayEgg"
}

ItsyScape.Resource.Item "WrenEgg" {
	ItsyScape.Action.ObtainSecondary() {
		Requirement {
			Count = ItsyScape.Utility.xpForLevel(45),
			Resource = ItsyScape.Resource.Skill "Woodcutting"
		},

		Requirement {
			Count = ItsyScape.Utility.xpForLevel(45),
			Resource = ItsyScape.Resource.Skill "Foraging"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(45),
			Resource = ItsyScape.Resource.Skill "Woodcutting"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(45),
			Resource = ItsyScape.Resource.Skill "Foraging"
		},

		Output {
			Count = 1,
			Resource = ItsyScape.Resource.Item "WrenEgg"
		}
	}
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Wren egg",
	Resource = ItsyScape.Resource.Item "WrenEgg"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "That's a pretty rare egg!.",
	Resource = ItsyScape.Resource.Item "WrenEgg"
}

ItsyScape.Meta.Item {
	Stackable = 1,
	Value = ItsyScape.Utility.valueForItem(45),
	Resource = ItsyScape.Resource.Item "WrenEgg"
}

ItsyScape.Meta.SecondaryWeight {
	Weight = 25,
	Resource = ItsyScape.Resource.Item "WrenEgg"
}

ItsyScape.Meta.Ingredient {
	Item = ItsyScape.Resource.Item "WrenEgg",
	Ingredient = ItsyScape.Resource.Ingredient "Egg"
}

ItsyScape.Meta.ItemUserdata {
	Item = ItsyScape.Resource.Item "WrenEgg",
	Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
}

ItsyScape.Meta.ItemValueUserdata {
	Resource = ItsyScape.Resource.Item "WrenEgg",
	Value = ItsyScape.Utility.valueForItem(45)
}

ItsyScape.Meta.ItemUserdata {
	Item = ItsyScape.Resource.Item "WrenEgg",
	Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
}

ItsyScape.Meta.ItemHealingUserdata {
	Hitpoints = 5,
	Resource = ItsyScape.Resource.Item "WrenEgg"
}
