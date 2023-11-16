--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/FruitTrees.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local TREES = {
	["Pecan"] = {
		niceName = "Pecan",
		ingredients = { "Fruit", "Pecan" },
		fruit = {
			{ name = "Pecan", tier = 1, factor = 2, health = -1 },
			{ name = "RegalPecan", tier = 10, factor = 2, health = -1 },
			{ name = "GoldenPecan", tier = 25, factor = 1, health = -1 },
		}
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
		}
	},
	["Pear"] = {
		niceName = "Pear",
		ingredients = { "Fruit", "Pear" },
		fruit = {
			{ name = "Pear", tier = 1, factor = 1.5, health = 1 },
			{ name = "DisgustingPear", tier = 15, factor = 1, health = -2 },
			{ name = "RottenPear", tier = 30, factor = 0.5, health = -4 },
			{ name = "JustMush", tier = 45, factor = 0.25, health = -8 },		}
	},
	["Peach"] = {
		niceName = "Peach",
		ingredients = { "Fruit", "Peach" },
		fruit = {
			{ name = "Peach", tier = 1, factor = 2, health = 1 },
			{ name = "JuicyPeach", tier = 20, factor = 1.5, health = 2 },
			{ name = "DonutPeach", tier = 40, factor = 0.5, health = 1 },
		}
	},
	["Orange"] = {
		niceName = "Orange",
		ingredients = { "Fruit", "Orange" },
		fruit = {
			{ name = "Orange", tier = 1, factor = 1.25, health = 1 },
			{ name = "SunnyOrange", tier = 20, factor = 1.0, health = 2 },
			{ name = "FireOrange", tier = 55, factor = 0.5, health = -4 },
		}
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

	ItsyScape.Meta.ResourceName {
		Value = string.format("%s tree", tree.niceName),
		Language = "en-US",
		Resource = Tree
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
	Resource = ItsyScape.Resource.Prop "PearTree_Default"
}

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
