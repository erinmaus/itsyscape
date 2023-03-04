--------------------------------------------------------------------------------
-- Resources/Game/DB/Gods/YeastBeast.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "YeastBeast" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.YeastBeast.YeastBeast",
	Resource = ItsyScape.Resource.Peep "YeastBeast"
}

ItsyScape.Meta.ResourceName {
	Value = "Saccharobyte, the Yeast Beast",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "YeastBeast"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Can make one mean loaf of bread.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "YeastBeast"
}

ItsyScape.Resource.Peep "YeastMite" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Arachnid.YeastMite",
	Resource = ItsyScape.Resource.Peep "YeastMite"
}

ItsyScape.Meta.ResourceName {
	Value = "Saccharomyte",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "YeastMite"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Also known as the common yeast mite.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "YeastMite"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(1),
	Resource = ItsyScape.Resource.Peep "YeastMite"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Arachnid/YeastMite_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "YeastMite"
}