--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/CraftedItem.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local CraftedItem = ItsyScape.Resource.Prop "CraftedItem"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.CraftedItem",
		Resource = CraftedItem
	}

	ItsyScape.Meta.ResourceName {
		Value = "Something being crafted",
		Language = "en-US",
		Resource = CraftedItem
	}

	ItsyScape.Meta.ResourceName {
		Value = "Something is being crafted here.",
		Language = "en-US",
		Resource = CraftedItem
	}
end
