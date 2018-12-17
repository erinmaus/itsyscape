--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/BoatFoam.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "BoatFoam_Small_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.PassableProp",
	Resource = ItsyScape.Resource.Prop "BoatFoam_Small_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 36,
	SizeY = 1.0,
	SizeZ = 12.0,
	OffsetX = -2,
	MapObject = ItsyScape.Resource.Prop "BoatFoam_Small_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Sea foam",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BoatFoam_Small_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Foamy!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BoatFoam_Small_Default"
}

ItsyScape.Resource.Prop "BoatFoamTrail_Small_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.PassableProp",
	Resource = ItsyScape.Resource.Prop "BoatFoamTrail_Small_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 15,
	SizeY = 1.0,
	SizeZ = 9.0,
	OffsetX = 25.0,
	MapObject = ItsyScape.Resource.Prop "BoatFoamTrail_Small_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Sea foam",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BoatFoamTrail_Small_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Frothy!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BoatFoamTrail_Small_Default"
}
