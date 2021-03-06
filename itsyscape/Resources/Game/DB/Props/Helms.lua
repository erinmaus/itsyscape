--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Sails.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Sailing_CommonHelm_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "Sailing_CommonHelm_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1,
	SizeY = 3,
	SizeZ = 1,
	MapObject = ItsyScape.Resource.Prop "Sailing_CommonHelm_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Helm",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Sailing_CommonHelm_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Steers the ship.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Sailing_CommonHelm_Default"
}

ItsyScape.Resource.Prop "Sailing_Player_CommonHelm" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "Sailing_Player_CommonHelm"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1,
	SizeY = 3,
	SizeZ = 1,
	MapObject = ItsyScape.Resource.Prop "Sailing_Player_CommonHelm"
}

ItsyScape.Meta.ResourceName {
	Value = "Common helm",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Sailing_Player_CommonHelm"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Steers the ship.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Sailing_Player_CommonHelm"
}
