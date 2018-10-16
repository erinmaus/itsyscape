--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Cow.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Cow_Base" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Cow.BaseCow",
	Resource = ItsyScape.Resource.Peep "Cow_Base"
}

ItsyScape.Meta.ResourceName {
	Value = "Cow",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Cow_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(10),
	Resource = ItsyScape.Resource.Peep "Cow_Base"
}
