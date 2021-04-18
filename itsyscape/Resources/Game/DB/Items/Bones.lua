--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Bones.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

BoneCraftAction = ItsyScape.Action.OpenInventoryCraftWindow()

ItsyScape.Meta.ActionVerb {
	Value = "Craft",
	XProgressive = "Crafting",
	Language = "en-US",
	Action = BoneCraftAction
}

ItsyScape.Meta.DelegatedActionTarget {
	CategoryKey = "Bones",
	ActionType = "Craft",
	Action = BoneCraftAction
}

ItsyScape.Resource.Item "Bones" {
	ItsyScape.Action.Bury() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Bones",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	},

	BoneCraftAction
}

ItsyScape.Meta.ResourceCategory {
	Key = "Bones",
	Value = "Bones", -- Well what else am I going to call it?
	Resource = ItsyScape.Resource.Item "Bones"
}

ItsyScape.Meta.ResourceName {
	Value = "Bones",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Bones"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(5) / 3,
	Weight = 5,
	Resource = ItsyScape.Resource.Item "Bones"
}

ItsyScape.Meta.ResourceDescription {
	Value = "There's no telling who or what these came from.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Bones"
}

ItsyScape.Resource.Item "BoneShards" {
	ItsyScape.Action.Craft() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Bones",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForResource(1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForResource(1)
		},

		Output {
			Resource = ItsyScape.Resource.Item "BoneShards",
			Count = 15
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Bone shards",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "BoneShards"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Shards carved from bones; used to barter with priests and demons alike",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "BoneShards"
}

ItsyScape.Meta.ResourceCategory {
	Key = "Bones",
	Value = "Bones", -- Well what else am I going to call it?
	Resource = ItsyScape.Resource.Item "BoneShards"
}

ItsyScape.Meta.Item {
	Value = 1,
	Weight = 0,
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "BoneShards"
}

ItsyScape.Resource.Item "DragonBones" {
	ItsyScape.Action.Bury() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(40)
		},

		Input {
			Resource = ItsyScape.Resource.Item "DragonBones",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForResource(40)
		}
	}
}

ItsyScape.Meta.ResourceCategory {
	Key = "Bones",
	Value = "DragonBones",
	Resource = ItsyScape.Resource.Item "DragonBones"
}

ItsyScape.Meta.ResourceName {
	Value = "Dragon bones",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "DragonBones"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(50),
	Weight = 20,
	Resource = ItsyScape.Resource.Item "DragonBones"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Still warm to the touch.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "DragonBones"
}

ItsyScape.Resource.Item "GildedDragonBones" {
	ItsyScape.Action.Bury() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(60)
		},

		Input {
			Resource = ItsyScape.Resource.Item "GildedDragonBones",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForResource(60)
		}
	},

	ItsyScape.Action.Smelt() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForLevel(55)
		},

		Input {
			Resource = ItsyScape.Resource.Item "GoldOre",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "DragonBones",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForResource(56)
		},

		Output {
			Resource = ItsyScape.Resource.Item "GildedDragonBones",
			Count = 1
		}
	}
}

ItsyScape.Meta.ResourceCategory {
	Key = "Bones",
	Value = "DragonBones",
	Resource = ItsyScape.Resource.Item "GildedDragonBones"
}

ItsyScape.Meta.ResourceCategory {
	Key = "Metal",
	Value = "Gold",
	Resource = ItsyScape.Resource.Item "GildedDragonBones"
}

ItsyScape.Meta.ResourceName {
	Value = "Gilded dragon bones",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GildedDragonBones"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(55) + ItsyScape.Utility.valueForItem(60),
	Weight = 25,
	Resource = ItsyScape.Resource.Item "GildedDragonBones"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Bones fit for the most regal of dogs.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GildedDragonBones"
}
