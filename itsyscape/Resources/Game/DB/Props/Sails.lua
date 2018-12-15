--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Sails.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Sailing_BasicSail_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.PassableProp",
	Resource = ItsyScape.Resource.Prop "Sailing_BasicSail_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 2,
	SizeY = 7,
	SizeZ = 12,
	OffsetX = -2,
	OffsetY = 5.5,
	MapObject = ItsyScape.Resource.Prop "Sailing_BasicSail_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Basic sail",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Sailing_BasicSail_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Full of wind.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Sailing_BasicSail_Default"
}
