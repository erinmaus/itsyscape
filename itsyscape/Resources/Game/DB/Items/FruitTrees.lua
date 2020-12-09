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
		fruit = {
			{ name = "Pecan", tier = 1, factor = 1.5, health = -1 },
			{ name = "RegalPecan", tier = 30, factor = 1.5, health = -1 },
			{ name = "GoldenPecan", tier = 60, factor = 3, health = -1 },
		}
	},
	["Apple"] = {
		niceName = "Apple",
		fruit = {
			{ name = "RedApple", tier = 1, factor = 1.5, health = 1 },
			{ name = "GreenApple", tier = 15, factor = 1.5, health = 1 },
			{ name = "SiliconApple", tier = 45, factor = 1.5, health = 2 },
			{ name = "GoldenApple", tier = 65, factor = 5, health = 2 },
			{ name = "WormyApple", tier = 130, factor = 15, health = -1 },
		}
	},
	["Pear"] = {
		niceName = "Pear",
		fruit = {
			{ name = "Pear", tier = 1, factor = 1.5, health = 1 },
			{ name = "DisgustingPear", tier = 30, factor = 1.5, health = -2 },
			{ name = "RottenPear", tier = 65, factor = 1.5, health = -4 },
			{ name = "JustMush", tier = 70, factor = 5, health = -8 },		}
	}
}

local DEFAULT_FACTOR = 1.5

for name, tree in pairs(TREES) do
	local TreeName = string.format("%sTree_Default", name)
	local Tree = ItsyScape.Resource.Prop(TreeName)

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicTree",
		Resource = Tree
	}

	Tree {
		ItsyScape.Action.Shake()
	}

	for i = 1, #tree.fruit do
		local fruit = tree.fruit[i]

		local Item = ItsyScape.Resource.Item(fruit.name)

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
				Count = ItsyScape.Utility.xpForResource(math.min(fruit.tier + 1, 99)) / #tree.fruit,
				Resource = ItsyScape.Resource.Skill "Foraging"
			}
		}

		ItsyScape.Meta.ForagingAction {
			Tier = fruit.tier,
			Factor = fruit.factor or DEFAULT_FACTOR,
			Action = GatherAction
		}

		ItsyScape.Meta.Item {
			Value = ItsyScape.Utility.valueForItem(math.min(fruit.tier + 1, 99)) / #tree.fruit,
			Stackable = 1,
			Resource = Item
		}

		local EatAction = ItsyScape.Action.Eat()

		ItsyScape.Meta.HealingPower {
			HitPoints = fruit.health,
			Action = EatAction
		}

		Item {
			EatAction
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

ItsyScape.Meta.ResourceDescription {
	Value = "That's one fine apple tree.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "AppleTree_Default"
}

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

ItsyScape.Meta.ResourceDescription {
	Value = "The worst of fruit trees.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "PearTree_Default"
}
