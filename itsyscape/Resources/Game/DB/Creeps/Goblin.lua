--------------------------------------------------------------------------------
-- Resources/Game/DB/Goblin.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Goblin_Base" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Goblin.BaseGoblin",
	Resource = ItsyScape.Resource.Peep "Goblin_Base"
}

ItsyScape.Meta.ResourceName {
	Value = "Goblin",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Goblin_Base"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Smelly and rude.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Goblin_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "Goblin_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "Goblin_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "Goblin_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(15),
	Resource = ItsyScape.Resource.Peep "Goblin_Base"
}
