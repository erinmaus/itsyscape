--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Ghost.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Ghost_Base" {
	-- Nothing.
}

ItsyScape.Meta.ResourceTag {
	Value = "Undead",
	Resource = ItsyScape.Resource.Peep "Ghost_Base"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Ghost.BaseGhost",
	Resource = ItsyScape.Resource.Peep "Ghost_Base"
}

ItsyScape.Meta.ResourceName {
	Value = "Ghost",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Ghost_Base"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The worst audience member at an opera.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Ghost_Base"
}