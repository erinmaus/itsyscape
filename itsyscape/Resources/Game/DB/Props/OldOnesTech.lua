--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/OldOnesTech.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Tesseract" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.PassableProp",
	Resource = ItsyScape.Resource.Prop "Tesseract"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1,
	SizeY = 1,
	SizeZ = 1,
	MapObject = ItsyScape.Resource.Prop "Tesseract"
}

ItsyScape.Meta.ResourceName {
	Value = "Tesseract",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Tesseract"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A higher dimensional computer.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Tesseract"
}
