--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Sky.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Cloud = ItsyScape.Resource.Prop "Cloud_Default"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.Cloud",
		Resource = Cloud
	}
end

do
	local Sun = ItsyScape.Resource.Prop "Sun_Default"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.Sun",
		Resource = Sun
	}
end

do
	local Moon = ItsyScape.Resource.Prop "Moon_Default"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.Moon",
		Resource = Moon
	}
end
