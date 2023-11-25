--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/ViziersRock/Palace.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Bench_ViziersRock" {
	-- Nothing
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "Bench_ViziersRock"
}

ItsyScape.Meta.ResourceName {
	Value = "Bench",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Bench_ViziersRock"
}

ItsyScape.Meta.ResourceDescription {
	Value = "What's the difference between a bench and a pew...?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Bench_ViziersRock"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 4.5,
	SizeY = 3,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Bench_ViziersRock"
}
