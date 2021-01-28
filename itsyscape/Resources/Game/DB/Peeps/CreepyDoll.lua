--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/CreepyDoll.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "CreepyDoll" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.CreepyDoll.CreepyDoll",
	Resource = ItsyScape.Resource.Peep "CreepyDoll"
}

ItsyScape.Meta.ResourceName {
	Value = "Creepy doll",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "CreepyDoll"
}

ItsyScape.Meta.ResourceDescription {
	Value = "There's something heart-breaking about her...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "CreepyDoll"
}
