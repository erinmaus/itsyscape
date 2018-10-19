--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

include "Resources/Game/DB/Maps/Rumbridge/IsabelleIsland_AbandonedMine.lua"
include "Resources/Game/DB/Maps/Rumbridge/IsabelleIsland_Tower.lua"

ItsyScape.Resource.Prop "Door_RumbridgeDungeon"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicDoor",
	Resource = ItsyScape.Resource.Prop "Door_RumbridgeDungeon"
}

ItsyScape.Meta.ResourceName {
	Value = "Dungeon door",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_RumbridgeDungeon"
}

ItsyScape.Resource.Prop "Door_RumbridgeStone"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicDoor",
	Resource = ItsyScape.Resource.Prop "Door_RumbridgeStone"
}

ItsyScape.Meta.ResourceName {
	Value = "Door",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_RumbridgeStone"
}
