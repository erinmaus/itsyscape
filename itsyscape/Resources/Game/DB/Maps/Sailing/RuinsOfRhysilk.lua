--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Sailing/RuinsOfRhysilk.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	ItsyScape.Resource.Prop "RuinsOfRhysilk_CastleLerper" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = ItsyScape.Resource.Prop "RuinsOfRhysilk_CastleLerper"
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 0,
		SizeY = 0,
		SizeZ = 0,
		MapObject = ItsyScape.Resource.Prop "RuinsOfRhysilk_CastleLerper"
	}
end
