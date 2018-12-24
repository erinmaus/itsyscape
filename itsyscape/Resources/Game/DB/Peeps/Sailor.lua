--------------------------------------------------------------------------------
-- Resources/Game/DB/Peeps/Sailor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Sailor_Panicked" {
	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "Sailor_Panicked_Primary",
			Count = 2
		}
	},

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "Sailor_Panicked_Secondary",
			Count = 1
		}
	}
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Sailors.PanickedSailor",
	Resource = ItsyScape.Resource.Peep "Sailor_Panicked"
}

ItsyScape.Meta.ResourceName {
	Value = "Sailor",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Sailor_Panicked"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Hard to tell they're not a landlubber.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Sailor_Panicked"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Pretty useless.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Sailor_Panicked"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Bottom of the barrel in seamanship.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Sailor_Panicked"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(10),
	Resource = ItsyScape.Resource.Peep "Sailor_Panicked"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "IronCannonball",
	Weight = 50,
	Count = 1,
	Range = 2,
	Resource = ItsyScape.Resource.DropTable "Sailor_Panicked_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Hammer",
	Weight = 50,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Sailor_Panicked_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "SailorsHat",
	Weight = 25,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Sailor_Panicked_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Bones",
	Weight = 1,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Sailor_Panicked_Secondary"	
}