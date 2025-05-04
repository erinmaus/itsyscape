--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Flare.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Flare = ItsyScape.Resource.Prop "Flare"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicFlare",
	Resource = Flare
}

ItsyScape.Meta.ResourceName {
	Value = "Flare",
	Language = "en-US",
	Resource = Flare
}

ItsyScape.Meta.ResourceDescription {
	Value = "Signals distress.",
	Language = "en-US",
	Resource = Flare
}
