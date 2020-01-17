--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Tiers.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

-- Metal
do
	ItsyScape.Meta.ResourceCategoryGroup {
		Key = "Metal",
		Value = "Copper",
		Tier = 0
	}

	ItsyScape.Meta.ResourceCategoryGroup {
		Key = "Metal",
		Value = "Tin",
		Tier = 0
	}

	ItsyScape.Meta.ResourceCategoryGroup {
		Key = "Metal",
		Value = "Bronze",
		Tier = 1
	}

	ItsyScape.Meta.ResourceCategoryGroup {
		Key = "Metal",
		Value = "Iron",
		Tier = 10
	}
end

-- Woods
do
	ItsyScape.Meta.ResourceCategoryGroup {
		Key = "Wood",
		Value = "Common",
		Tier = 1
	}

	ItsyScape.Meta.ResourceCategoryGroup {
		Key = "Wood",
		Value = "Shadow",
		Tier = 1
	}

	ItsyScape.Meta.ResourceCategoryGroup {
		Key = "Wood",
		Value = "Willow",
		Tier = 1
	}

	ItsyScape.Meta.ResourceCategoryGroup {
		Key = "Wood",
		Value = "Azathothian",
		Tier = 90
	}
end
