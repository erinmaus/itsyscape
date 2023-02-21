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
