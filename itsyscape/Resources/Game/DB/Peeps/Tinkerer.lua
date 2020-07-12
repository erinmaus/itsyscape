--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Tinkerer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Tinkerer" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Tinkerer.BaseTinkerer",
	Resource = ItsyScape.Resource.Peep "Tinkerer"
}

ItsyScape.Meta.ResourceName {
	Value = "Tinkerer",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Tinkerer"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The best kind of medic... when you're dead.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Tinkerer"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(100),
	Resource = ItsyScape.Resource.Peep "Tinkerer"
}
