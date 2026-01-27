--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/ColorfulFire.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local ColorfulFire = ItsyScape.Resource.Prop "ColorfulFire"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicPointLight",
	Resource = ColorfulFire
}

ItsyScape.Meta.ResourceName {
	Value = "Colorful fire",
	Language = "en-US",
	Resource = ColorfulFire
}

ItsyScape.Meta.ResourceDescription {
	Value = "A colorful, uncontrolled fire.",
	Language = "en-US",
	Resource = ColorfulFire
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 2,
	SizeZ = 1.5,
	MapObject = ColorfulFire
}
