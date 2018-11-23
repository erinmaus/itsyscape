--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Bones.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "Bones" {
	ItsyScape.Action.Bury() {
		Input {
			Resource = ItsyScape.Resource.Item "Bones",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	},

	ItsyScape.Action.Craft() {
		Requirement {
			Resource = ItsyScape.Resource.Item "Crafting",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Faith",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Bones",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "BoneShards",
			Count = 15
		}
	}
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

ItsyScape.Resource.Item "BoneShards" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Bone shards",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "BoneShards"
}

ItsyScape.Meta.Item {
	Value = 1,
	Weight = 0,
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "BoneShards"
}
