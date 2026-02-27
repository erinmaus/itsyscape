------------------------------------------------------------------------------
-- Resources/Game/ActionCommands/Fish.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Water = ItsyScape.Resource.Prop "ActionCommand_OceanWater1"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = Water
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 13,
		SizeY = 1,
		SizeZ = 13,
		MapObject = Water
	}
end

do
	local Cursor = ItsyScape.Resource.Prop "FishingCursor"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicCursor",
		Resource = Cursor
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1.5,
		SizeY = 1,
		SizeZ = 1.5,
		MapObject = Cursor
	}
end

do
	local Fish1 = ItsyScape.Resource.ActionCommand "Fish1"

	ItsyScape.Meta.ActionCommandMap {
		Map = ItsyScape.Resource.Map "Skilling_Fishing1",
		Resource = Fish1
	}
end

do
	local FishAncientKaradon = ItsyScape.Resource.ActionCommand "FishAncientKaradon"

	ItsyScape.Meta.ActionCommandMap {
		Map = ItsyScape.Resource.Map "Skilling_FishingAncientKaradon",
		Resource = FishAncientKaradon
	}
end
