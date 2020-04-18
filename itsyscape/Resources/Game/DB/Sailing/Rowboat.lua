--------------------------------------------------------------------------------
-- Resources/Game/DB/Sailing/Rowboat.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Rowboat_Default" {
	-- Nothing.
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 4.5,
	SizeY = 1.5,
	SizeZ = 6.5,
	MapObject = ItsyScape.Resource.Prop "Rowboat_Default"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "Rowboat_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Rowboat",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Rowboat_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Takes you to and from the ship.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Rowboat_Default"
}