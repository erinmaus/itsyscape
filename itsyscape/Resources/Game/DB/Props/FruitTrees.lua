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
			{ name = "Pecan", tier = 1, factor = 1.5 },
			{ name = "RegalPecan", tier = 30, factor = 1.5 },
			{ name = "GoldenPecan", tier = 60, factor = 3 },
		}
	}
}

local DEFAULT_FACTOR = 1.5

for name, tree in pairs(TREES) do
	local TreeName = string.format("%sTree_Default", name)
	local Tree = ItsyScape.Resource.Prop(TreeName)

	for i = 1, #tree.fruit do
		local fruit = tree.fruit[i]

		local Action = ItsyScape.Action.Gather() {
			Requirement {
				Count = ItsyScape.Utility.xpForLevel(fruit.tier),
				Resource = ItsyScape.Resource.Skill "Foraging"
			},

			Output {
				Count = 1,
				Resource = ItsyScape.Resource.Item(fruit.name)
			},

			Output {
				Count = ItsyScape.Utility.xpForResource(fruit.tier + 1) / #tree.fruit,
				Resource = ItsyScape.Resource.Skill "Foraging"
			}
		}

		ItsyScape.Meta.ForagingAction {
			Tier = fruit.tier,
			Factor = fruit.factor or DEFAULT_FACTOR,
			Action = Action
		}
	end

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicTree",
		Resource = Tree
	}

	Tree {
		ItsyScape.Action.Shake()
	}

	ItsyScape.Meta.ResourceName {
		Value = string.format("%s tree", tree.niceName),
		Language = "en-US",
		Resource = Tree
	}
end
