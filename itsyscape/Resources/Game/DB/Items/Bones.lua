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
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Bones",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Bones"
}
