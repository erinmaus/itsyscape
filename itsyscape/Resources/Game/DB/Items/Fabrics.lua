--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Leathers.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local CraftAction = ItsyScape.Action.OpenInventoryCraftWindow()

ItsyScape.Meta.ActionVerb {
	Value = "Craft",
	Language = "en-US",
	Action = CraftAction
}

ItsyScape.Meta.DelegatedActionTarget {
	CategoryKey = "Fabric",
	CategoryValue = "BlueCotton",
	ActionType = "Craft",
	Action = CraftAction
}

ItsyScape.Resource.Item "BlueCotton" {
	CraftAction
}

ItsyScape.Meta.ResourceName {
	Value = "Blue cotton",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "BlueCotton"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(3),
	Weight = 0.5,
	Resource = ItsyScape.Resource.Item "BlueCotton"
}
