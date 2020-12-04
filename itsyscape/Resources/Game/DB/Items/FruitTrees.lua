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
				Count = ItsyScape.Utility.xpForResource(fruit.tier + 1) / #tree.fruit,
				Resource = ItsyScape.Resource.Skill "Foraging"
			}
		}

		ItsyScape.Meta.ForagingAction {
			Tier = fruit.tier,
			Factor = fruit.factor or DEFAULT_FACTOR,
			Action = GatherAction
		}

		ItsyScape.Meta.Item {
			Value = ItsyScape.Utility.valueForItem(fruit.tier + 1) / #tree.fruit,
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
