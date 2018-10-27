--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge/IsabelleIsland_FoggyForest.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local ChopAction = ItsyScape.Action.Chop() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Woodcutting",
			Count = ItsyScape.Utility.xpForLevel(0)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Woodcutting",
			Count = ItsyScape.Utility.xpForResource(10)
		},

		Output {
			Resource = ItsyScape.Resource.Item "CommonLogs",
			Count = 2
		}
	}

	ItsyScape.Meta.ActionDifficulty {
		Value = 1,
		Action = ChopAction
	}

	ItsyScape.Resource.Prop "IsabelleIsland_FoggyForest_AncientDriftwoodTree" {
		ChopAction
	}

	ItsyScape.Meta.GatherableProp {
		Health = 10,
		SpawnTime = math.huge,
		Resource = ItsyScape.Resource.Prop "IsabelleIsland_FoggyForest_AncientDriftwoodTree"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicTree",
		Resource = ItsyScape.Resource.Prop "IsabelleIsland_FoggyForest_AncientDriftwoodTree"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Ancient driftwood",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "IsabelleIsland_FoggyForest_AncientDriftwoodTree"
	}
end
