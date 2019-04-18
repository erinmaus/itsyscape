--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Chandelier.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Chandelier_Default" {
	-- Nothing
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.PassableProp",
	Resource = ItsyScape.Resource.Prop "Chandelier_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Chandelier",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Chandelier_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "I hope it doesn't fall...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Chandelier_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 12,
	SizeY = 8,
	SizeZ = 10,
	MapObject = ItsyScape.Resource.Prop "Chandelier_Default"
}
