--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Log.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local LOGS = {
	["Common"] = {
		tier = 0,
		weight = 8,
		health = 6
	}
}

for name, log in pairs(LOGS) do
	local ItemName = string.format("%sLogs", name)
	local Log = ItsyScape.Resource.Item(ItemName)

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(log.tier),
		Weight = log.weight,
		Resource = Log
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Wood",
		Value = name,
		Resource = Log
	}

	ItsyScape.Meta.ResourceName {
		Value = string.format("%s logs", name),
		Language = "en-US",
		Resource = Log
	}

	local TreeName = string.format("%sTree_Default", name)
	local Tree = ItsyScape.Resource.Prop(TreeName)

	local ChopAction = ItsyScape.Action.Chop()

	ChopAction {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Woodcutting",
			Count = ItsyScape.Utility.xpForLevel(math.max(log.tier, 0))
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Woodcutting",
			Count = ItsyScape.Utility.xpForResource(math.max(log.tier, 1)) * 4
		},

		Output {
			Resource = Log,
			Count = 1
		}
	}

	ItsyScape.Meta.ActionDifficulty {
		Value = math.max(log.tier + 10),
		Action = ChopAction
	}

	ItsyScape.Meta.GatherableProp {
		Health = log.health,
		SpawnTime = log.tier + 10,
		Resource = Tree
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicTree",
		Resource = Tree
	}

	Tree { ChopAction }

	ItsyScape.Meta.ResourceName {
		Value = string.format("%s tree", name),
		Language = "en-US",
		Resource = Tree
	}
end
