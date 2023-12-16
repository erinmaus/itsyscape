--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Target.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Target_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicTarget",
	Resource = ItsyScape.Resource.Prop "Target_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 0,
	SizeY = 0,
	SizeZ = 0,
	MapObject = ItsyScape.Resource.Prop "Target_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Target",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Target_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Attack!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Target_Default"
}
