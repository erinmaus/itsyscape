--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Buckets.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "Bucket" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Bucket",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Bucket"
}

ItsyScape.Meta.Item {
	Value = 1,
	Weight = 1,
	Resource = ItsyScape.Resource.Item "Bucket"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Can store many things, maybe other buckets!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Bucket"
}

local DigUpBucketOfSand = ItsyScape.Action.DigUp() {
	Requirement {
		Resource = ItsyScape.Resource.Skill "Mining",
		Count = ItsyScape.Utility.xpForLevel(1)
	},

	Input {
		Resource = ItsyScape.Resource.Item "Bucket",
		Count = 1
	},

	Output {
		Resource = ItsyScape.Resource.Item "BucketOfSand",
		Count = 1
	},

	Output {
		Resource = ItsyScape.Resource.Skill "Mining",
		Count = ItsyScape.Utility.xpForResource(2)
	}
}

ItsyScape.Meta.ActionSpawnProp {
	Prop = ItsyScape.Resource.Prop "Hole_Default",
	Action = DigUpBucketOfSand
}

ItsyScape.Resource.Item "BucketOfSand" {
	DigUpBucketOfSand
}

ItsyScape.Meta.ResourceName {
	Value = "Bucket of sand",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "BucketOfSand"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(5),
	Weight = 5,
	Resource = ItsyScape.Resource.Item "BucketOfSand"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A bucket full of sand; it's coarse and it gets everywhere!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "BucketOfSand"
}

do
	local CraftAction = ItsyScape.Action.OpenInventoryCraftWindow()

	ItsyScape.Meta.ActionVerb {
		Value = "Craft",
		XProgressive = "Crafting",
		Language = "en-US",
		Action = CraftAction
	}

	ItsyScape.Meta.DelegatedActionTarget {
		CategoryKey = "Glass",
		ActionType = "Craft",
		Action = CraftAction
	}

	ItsyScape.Resource.Item "BucketOfMoltenGlass" {
		ItsyScape.Action.Smelt() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "BucketOfSand",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "BucketOfMoltenGlass",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForResource(10)
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForResource(10)
			}
		},
		CraftAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = "Sand",
		Resource = ItsyScape.Resource.Item "BucketOfMoltenGlass"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Bucket of molten glass",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BucketOfMoltenGlass"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(10),
		Weight = 5,
		Resource = ItsyScape.Resource.Item "BucketOfMoltenGlass"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "How in the world is that bucket holding that?",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BucketOfMoltenGlass"
	}
end