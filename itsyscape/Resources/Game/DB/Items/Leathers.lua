--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Leathers.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "PlainThread" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Plain thread",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "PlainThread"
}

ItsyScape.Meta.Item {
	Value = 1,
	Weight = 0,
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "PlainThread"
}

local CraftAction = ItsyScape.Action.OpenInventoryCraftWindow()

ItsyScape.Meta.ActionVerb {
	Value = "Craft",
	Language = "en-US",
	Action = CraftAction
}

ItsyScape.Meta.DelegatedActionTarget {
	CategoryKey = "Leather",
	CategoryValue = "MooishLeather",
	ActionType = "Craft",
	Action = CraftAction
}

ItsyScape.Resource.Item "MooishLeatherHide" {
	CraftAction
}

ItsyScape.Meta.ResourceName {
	Value = "Mooish leather",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "MooishLeatherHide"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(2),
	Weight = 2,
	Resource = ItsyScape.Resource.Item "MooishLeatherHide"
}
