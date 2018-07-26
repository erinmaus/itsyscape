--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge/IsabelleIsland_AbandonedMine.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "IsabelleIsland_AbandonedMine_WroughtBronzeKey" {
	-- Nothing.
}

ItsyScape.Meta.Item {
	Value = 1,
	Weight = 0,
	Resource = ItsyScape.Resource.Item "IsabelleIsland_AbandonedMine_WroughtBronzeKey"
}

ItsyScape.Resource.Prop "IsabelleIsland_AbandonedMine_EntranceDoor" {
	ItsyScape.Action.Open() {
		--Requirement {
		--	Resource = ItsyScape.Resource.Item "IsabelleIsland_AbandonedMine_WroughtBronzeKey",
		--	Count = 1
		--}
	},

	ItsyScape.Action.Close() {
		-- Nothing.
	}
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicDoor",
	Resource = ItsyScape.Resource.Prop "IsabelleIsland_AbandonedMine_EntranceDoor"
}

ItsyScape.Meta.ResourceName {
	Value = "Door",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "IsabelleIsland_AbandonedMine_EntranceDoor"
}
