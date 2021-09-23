--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/TVMimic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "TVMimic" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.ChestMimic.TVMimic",
	Resource = ItsyScape.Resource.Peep "TVMimic"
}

ItsyScape.Meta.ResourceName {
	Value = "TV mimic",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "TVMimic"
}

ItsyScape.Meta.ResourceDescription {
	Value = "I still don't know what a TV is.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "TVMimic"
}

ItsyScape.Resource.Prop "TV_Mimic" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.ChestMimic.TVMimicBody",
	Resource = ItsyScape.Resource.Prop "TV_Mimic"
}

ItsyScape.Meta.ResourceName {
	Value = "TV mimic body",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "TV_Mimic"
}

ItsyScape.Meta.ResourceDescription {
	Value = "That's weird, I shouldn't be able to examine this proxy object!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "TV_Mimic"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 0,
	SizeY = 0,
	SizeZ = 0,
	MapObject = ItsyScape.Resource.Prop "TV_Mimic"
}
