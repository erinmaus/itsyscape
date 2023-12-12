--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/FruitTrees.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local FRUIT_TREE_SECONDARIES = {
	"Leaf",
	"Branch"
}

local COMMON_SECONDARIES = {
	"CommonBlackSpider",
	"CommonTreeMoth",
	"CommonTreeBeetle",
	"RobinEgg",
	"CardinalEgg",
	"BlueJayEgg",
	"WrenEgg",
}

local TREES = {
	["Pecan"] = {
		niceName = "Pecan",
		ingredients = { "Fruit", "Pecan" },
		fruit = {
			{ name = "Pecan", tier = 1, factor = 2, health = -1 },
			{ name = "RegalPecan", tier = 10, factor = 2, health = -1 },
			{ name = "GoldenPecan", tier = 25, factor = 1, health = -1 },
		},
		woodcutting = 10
	},
	["Apple"] = {
		niceName = "Apple",
		ingredients = { "Fruit", "Apple" },
		fruit = {
			{ name = "RedApple", tier = 1, factor = 1.5, health = 1 },
			{ name = "GreenApple", tier = 10, factor = 1.5, health = 1 },
			{ name = "SiliconApple", tier = 20, factor = 1.5, health = 2 },
			{ name = "GoldenApple", tier = 50, factor = 0.5, health = 2 },
			{ name = "WormyApple", tier = 99, factor = 0.125, health = -1 },
		},
		woodcutting = 1
	},
	["Pear"] = {
		niceName = "Pear",
		ingredients = { "Fruit", "Pear" },
		fruit = {
			{ name = "Pear", tier = 1, factor = 1.5, health = 1 },
			{ name = "DisgustingPear", tier = 15, factor = 1, health = -2 },
			{ name = "RottenPear", tier = 30, factor = 0.5, health = -4 },
			{ name = "JustMush", tier = 45, factor = 0.25, health = -8 },
		},
		woodcutting = 20
	},
	["Peach"] = {
		niceName = "Peach",
		ingredients = { "Fruit", "Peach" },
		fruit = {
			{ name = "Peach", tier = 1, factor = 2, health = 1 },
			{ name = "JuicyPeach", tier = 20, factor = 1.5, health = 2 },
			{ name = "DonutPeach", tier = 40, factor = 0.5, health = 1 },
		},
		woodcutting = 10
	},
	["Orange"] = {
		niceName = "Orange",
		ingredients = { "Fruit", "Orange" },
		fruit = {
			{ name = "Orange", tier = 1, factor = 1.25, health = 1 },
			{ name = "SunnyOrange", tier = 20, factor = 1.0, health = 2 },
			{ name = "FireOrange", tier = 55, factor = 0.5, health = -4 },
		},
		woodcutting = 30
	}
}

local DEFAULT_FACTOR = 1.5

for name, tree in spairs(TREES) do
	local TreeName = string.format("%sTree_Default", name)
	local Tree = ItsyScape.Resource.Prop(TreeName)

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicTree",
		Resource = Tree
	}

	ItsyScape.Meta.PropAnchor {
		OffsetI = 0,
		OffsetJ = 0,
		Resource = Tree
	}

	Tree {
		ItsyScape.Action.Shake()
	}

	for i = 1, #tree.fruit do
		local fruit = tree.fruit[i]

		local Item = ItsyScape.Resource.Item(fruit.name)

		for j = 1, #tree.ingredients do
			ItsyScape.Meta.Ingredient {
				Item = Item,
				Ingredient = ItsyScape.Resource.Ingredient(tree.ingredients[j])
			}
		end

		local GatherAction = ItsyScape.Action.Gather() {
			Requirement {
				Count = ItsyScape.Utility.xpForLevel(fruit.tier),
				Resource = ItsyScape.Resource.Skill "Foraging"
			},

			Output {
				Count = 1,
				Resource = Item
			},

			Output {
				Count = ItsyScape.Utility.xpForResource(math.min(fruit.tier + 1, 99)),
				Resource = ItsyScape.Resource.Skill "Foraging"
			}
		}

		ItsyScape.Meta.ForagingAction {
			Tier = fruit.tier,
			Factor = fruit.factor or DEFAULT_FACTOR,
			Action = GatherAction
		}

		local value = ItsyScape.Utility.valueForItem(math.min(fruit.tier + 1, 99)) / #tree.fruit,
		ItsyScape.Meta.Item {
			Value = value,
			Stackable = 1,
			Resource = Item
		}

		local EatAction = ItsyScape.Action.Eat()

		ItsyScape.Meta.HealingPower {
			HitPoints = fruit.health,
			Action = EatAction
		}

		local CookAction = ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(fruit.tier)
			},

			Input {
				Resource = Item,
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(fruit.tier + 1)
			}
		}

		Item {
			EatAction,
			CookAction
		}

		ItsyScape.Meta.ItemUserdata {
			Item = Item,
			Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
		}

		ItsyScape.Meta.ItemValueUserdata {
			Resource = Item,
			Value = value
		}

		Tree {
			GatherAction
		}
	end

	ItsyScape.Meta.GatherableProp {
		Health = math.max(tree.woodcutting + 5, 10),
		SpawnTime = 0,
		Resource = Tree
	}

	for _, secondary in ipairs(FRUIT_TREE_SECONDARIES) do
		local SecondaryItemName = string.format("%s%s", name, secondary)
		local SecondaryItem = ItsyScape.Resource.Item(SecondaryItemName)

		SecondaryItem {
			ItsyScape.Action.ObtainSecondary() {
				Requirement {
					Resource = ItsyScape.Resource.Skill "Foraging",
					Count = ItsyScape.Utility.xpForLevel(math.max(tree.woodcutting, 0))
				},

				Requirement {
					Resource = ItsyScape.Resource.Skill "Woodcutting",
					Count = ItsyScape.Utility.xpForLevel(math.max(tree.woodcutting, 0))
				},

				Output {
					Resource = ItsyScape.Resource.Skill "Foraging",
					Count = math.ceil(ItsyScape.Utility.xpForResource(math.max(tree.woodcutting, 1)) / 4)
				},

				Output {
					Resource = ItsyScape.Resource.Skill "Woodcutting",
					Count = math.ceil(ItsyScape.Utility.xpForResource(math.max(tree.woodcutting, 1)) / 4)
				},

				Output {
					Resource = SecondaryItem,
					Count = 1
				}
			}
		}

		ItsyScape.Meta.SecondaryWeight {
			Weight = 500,
			Resource = SecondaryItem
		}

		ItsyScape.Meta.Item {
			Stackable = 1,
			Value = ItsyScape.Utility.valueForItem(math.max(tree.woodcutting, 1)),
			Resource = SecondaryItem
		}

		Tree {
			ItsyScape.Action.ObtainSecondary() {
				Output {
					Resource = SecondaryItem,
					Count = 1
				}
			}
		}
	end

	for _, secondary in ipairs(COMMON_SECONDARIES) do
		Tree {
			ItsyScape.Action.ObtainSecondary() {
				Output {
					Resource = ItsyScape.Resource.Item(secondary),
					Count = 1
				}
			}
		}
	end

	ItsyScape.Meta.ResourceName {
		Value = string.format("%s tree", tree.niceName),
		Language = "en-US",
		Resource = Tree
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Pecan leaf",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PecanLeaf"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A leaf from a pecan tree.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PecanBranch"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Pecan branch",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PecanBranch"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A branch from a pecan tree. Good for kindling.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PecanBranch"
	}

	ItsyScape.Resource.Item "PecanBranch" {
		ItsyScape.Action.Burn() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Firemaking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "Tinderbox",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "PecanBranch",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Firemaking",
				Count = ItsyScape.Utility.xpForResource(10)
			}
		}
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Pecan",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Pecan"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A basic pecan.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Pecan"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "Pecan",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "Pecan",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemPrayerRestorationUserdata"
	}

	ItsyScape.Meta.ItemPrayerRestorationUserdata {
		PrayerPoints = 1,
		Resource = ItsyScape.Resource.Item "Pecan"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Faith",
		Boost = 1,
		Resource = ItsyScape.Resource.Item "Pecan"
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Regal pecan",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RegalPecan"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A regal pecan.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RegalPecan"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "RegalPecan",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "RegalPecan",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemPrayerRestorationUserdata"
	}

	ItsyScape.Meta.ItemPrayerRestorationUserdata {
		PrayerPoints = 4,
		Resource = ItsyScape.Resource.Item "RegalPecan"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Faith",
		Boost = 2,
		Resource = ItsyScape.Resource.Item "RegalPecan"
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Golden pecan",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "GoldenPecan"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The big nut.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "GoldenPecan"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Get a load of these nuts.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "PecanTree_Default"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "GoldenPecan",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "GoldenPecan",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemPrayerRestorationUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Faith",
		Boost = 5,
		Resource = ItsyScape.Resource.Item "GoldenPecan"
	}

	ItsyScape.Meta.ItemPrayerRestorationUserdata {
		PrayerPoints = 10,
		Resource = ItsyScape.Resource.Item "GoldenPecan"
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Apple leaf",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AppleLeaf"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A leaf from an apple tree.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AppleLeaf"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Apple branch",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AppleBranch"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A branch from an apple tree. Good for kindling.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AppleBranch"
	}

	ItsyScape.Resource.Item "AppleBranch" {
		ItsyScape.Action.Burn() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Firemaking",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "Tinderbox",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "AppleBranch",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Firemaking",
				Count = ItsyScape.Utility.xpForResource(1)
			}
		}
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Red apple",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RedApple"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A basic, boring apple.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RedApple"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "RedApple",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "RedApple",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 2,
		Resource = ItsyScape.Resource.Item "RedApple"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Boost = 1,
		Resource = ItsyScape.Resource.Item "RedApple"
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Green apple",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "GreenApple"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Green apples are the best!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "GreenApple"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "GreenApple",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "GreenApple",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 3,
		Resource = ItsyScape.Resource.Item "GreenApple"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Boost = 3,
		Resource = ItsyScape.Resource.Item "GreenApple"
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Silicon apple",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SiliconApple"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Tastes like the future.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SiliconApple"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "SiliconApple",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "SiliconApple",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 5,
		Resource = ItsyScape.Resource.Item "SiliconApple"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Engineering",
		Boost = 2,
		Resource = ItsyScape.Resource.Item "SiliconApple"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Boost = 5,
		Resource = ItsyScape.Resource.Item "SiliconApple"
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Golden apple",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "GoldenApple"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Maybe not as cool as a golden globe.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "GoldenApple"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "GoldenApple",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "GoldenApple",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 5,
		Resource = ItsyScape.Resource.Item "GoldenApple"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Boost = 5,
		Resource = ItsyScape.Resource.Item "GoldenApple"
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Wormy apple",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "WormyApple"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Ew, there's a worm in this apple!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "WormyApple"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "WormyApple",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "WormyApple",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 30,
		IsZealous = 1,
		Resource = ItsyScape.Resource.Item "WormyApple"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Engineering",
		Boost = 10,
		Resource = ItsyScape.Resource.Item "WormyApple"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Boost = 10,
		Resource = ItsyScape.Resource.Item "WormyApple"
	}
end

ItsyScape.Meta.ResourceDescription {
	Value = "That's one fine apple tree.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "AppleTree_Default"
}

do
	ItsyScape.Meta.ResourceName {
		Value = "Pear leaf",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PearLeaf"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A leaf from a pear tree.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PearLeaf"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Pear branch",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PearBranch"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A branch from a pear tree. Good for kindling.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PearBranch"
	}

	ItsyScape.Resource.Item "PearBranch" {
		ItsyScape.Action.Burn() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Firemaking",
				Count = ItsyScape.Utility.xpForLevel(20)
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "Tinderbox",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "PearBranch",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Firemaking",
				Count = ItsyScape.Utility.xpForResource(20)
			}
		}
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Pear",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Pear"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Deceivingly good looking.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Pear"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "Pear",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Necromancy",
		Boost = 1,
		Resource = ItsyScape.Resource.Item "Pear"
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Disgusting pear",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "DisgustingPear"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "This pear shows its true colors.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "DisgustingPear"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "DisgustingPear",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Necromancy",
		Boost = 2,
		Resource = ItsyScape.Resource.Item "DisgustingPear"
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Rotten pear",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RottenPear"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A rotten pear, prone to attracting flies.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RottenPear"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "RottenPear",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Necromancy",
		Boost = 3,
		Resource = ItsyScape.Resource.Item "RottenPear"
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Just mush",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "JustMush"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Was this ever even a pear?",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "JustMush"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "JustMush",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Necromancy",
		Boost = 5,
		Resource = ItsyScape.Resource.Item "JustMush"
	}
end

ItsyScape.Meta.ResourceDescription {
	Value = "The worst of fruit trees.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "PearTree_Default"
}

do
	ItsyScape.Meta.ResourceName {
		Value = "Peach leaf",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PeachLeaf"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A leaf from a peach tree.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PeachLeaf"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Peach branch",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PeachBranch"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A branch from a peach tree. Good for kindling.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PeachBranch"
	}

	ItsyScape.Resource.Item "PeachBranch" {
		ItsyScape.Action.Burn() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Firemaking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "Tinderbox",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "PeachBranch",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Firemaking",
				Count = ItsyScape.Utility.xpForResource(10)
			}
		}
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Peach",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Peach"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Pretty as a peach!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Peach"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "Peach",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "Peach",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 1,
		Resource = ItsyScape.Resource.Item "Peach"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Archery",
		Boost = 2,
		Resource = ItsyScape.Resource.Item "Peach"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Boost = 2,
		Resource = ItsyScape.Resource.Item "Peach"
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Juicy peach",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "JuicyPeach"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Why isn't this an emoji yet?",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "JuicyPeach"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "JuicyPeach",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "JuicyPeach",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 5,
		Resource = ItsyScape.Resource.Item "JuicyPeach"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Archery",
		Boost = 4,
		Resource = ItsyScape.Resource.Item "JuicyPeach"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Boost = 4,
		Resource = ItsyScape.Resource.Item "JuicyPeach"
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Donut peach",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "DonutPeach"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Donut peach or peach donut?",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "DonutPeach"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "DonutPeach",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "DonutPeach",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 5,
		Resource = ItsyScape.Resource.Item "DonutPeach"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Archery",
		Boost = 5,
		Resource = ItsyScape.Resource.Item "DonutPeach"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Boost = 5,
		Resource = ItsyScape.Resource.Item "DonutPeach"
	}
end

ItsyScape.Meta.ResourceDescription {
	Value = "From top to bottom, what a good looking tree!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "PeachTree_Default"
}

do
	ItsyScape.Meta.ResourceName {
		Value = "Orange leaf",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "OrangeLeaf"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A leaf from an orange tree.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "OrangeLeaf"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Orange branch",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "OrangeBranch"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A branch from an orange tree. Good for kindling.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "OrangeBranch"
	}

	ItsyScape.Resource.Item "OrangeBranch" {
		ItsyScape.Action.Burn() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Firemaking",
				Count = ItsyScape.Utility.xpForLevel(30)
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "Tinderbox",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "OrangeBranch",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Firemaking",
				Count = ItsyScape.Utility.xpForResource(30)
			}
		}
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Orange",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Orange"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Orange you glad I didn't say banana?",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Orange"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "Orange",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "Orange",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 2,
		Resource = ItsyScape.Resource.Item "Orange"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Attack",
		Boost = 2,
		Resource = ItsyScape.Resource.Item "Orange"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Strength",
		Boost = 2,
		Resource = ItsyScape.Resource.Item "Orange"
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Sunny orange",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SunnyOrange"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "They're warm to the touch.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SunnyOrange"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "SunnyOrange",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "SunnyOrange",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 2,
		Resource = ItsyScape.Resource.Item "SunnyOrange"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Attack",
		Boost = 5,
		Resource = ItsyScape.Resource.Item "SunnyOrange"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Strength",
		Boost = 5,
		Resource = ItsyScape.Resource.Item "SunnyOrange"
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Fire orange",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "FireOrange"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "So spicy it will damage your mouth!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "FireOrange"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "FireOrange",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "FireOrange",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 5,
		Resource = ItsyScape.Resource.Item "FireOrange"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Attack",
		Boost = 8,
		Resource = ItsyScape.Resource.Item "FireOrange"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Strength",
		Boost = 8,
		Resource = ItsyScape.Resource.Item "FireOrange"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Firemaking",
		Boost = 10,
		Resource = ItsyScape.Resource.Item "FireOrange"
	}
end

ItsyScape.Meta.ResourceDescription {
	Value = "Knock knock!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "OrangeTree_Default"
}
