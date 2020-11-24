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

ItsyScape.Meta.ResourceDescription {
	Value = "Not particularly strong, but it's good enough for most things.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "PlainThread"
}

ItsyScape.Meta.Item {
	Value = 1,
	Weight = 0,
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "PlainThread"
}

do
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

	ItsyScape.Meta.ResourceDescription {
		Value = "Who doesn't love cow print?",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MooishLeatherHide"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(2),
		Weight = 2,
		Resource = ItsyScape.Resource.Item "MooishLeatherHide"
	}
end

do
	local CraftAction = ItsyScape.Action.OpenInventoryCraftWindow()

	ItsyScape.Meta.ActionVerb {
		Value = "Craft",
		Language = "en-US",
		Action = CraftAction
	}

	ItsyScape.Meta.DelegatedActionTarget {
		CategoryKey = "Leather",
		CategoryValue = "BugGuts",
		ActionType = "Craft",
		Action = CraftAction
	}

	ItsyScape.Resource.Item "BugGutsHide" {
		CraftAction
	}

	ItsyScape.Meta.ResourceName {
		Value = "Chocoroach bug guts",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BugGutsHide"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The leg! It's still twitching! Blegh!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BugGutsHide"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(12),
		Weight = 1.5,
		Resource = ItsyScape.Resource.Item "BugGutsHide"
	}
end
