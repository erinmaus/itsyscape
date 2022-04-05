--------------------------------------------------------------------------------
-- Resources/Game/DB/Gods/Yendor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Yendor_Base" {
	-- Nothing.
}

ItsyScape.Meta.ResourceTag {
	Value = "Eldritch",
	Resource = ItsyScape.Resource.Peep "Yendor_Base"
}

ItsyScape.Meta.ResourceTag {
	Value = "OldOne",
	Resource = ItsyScape.Resource.Peep "Yendor_Base"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Yendor.BaseYendor",
	Resource = ItsyScape.Resource.Peep "Yendor_Base"
}

ItsyScape.Meta.ResourceName {
	Value = "Yendor",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Yendor_Base"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Tremble, mortals! Madness will consume you! Give up, give in. Yendor's will is unbreakable.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Yendor_Base"
}
