--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Leathers.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "Sapphire" {
	ItsyScape.Action.ObtainSecondary() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForResource(10)
		},

		Output {
			Resource = ItsyScape.Resource.Item "Sapphire",
			Count = 1
		}
	}
}

ItsyScape.Meta.SecondaryWeight {
	Weight = 20,
	Resource = ItsyScape.Resource.Item "Sapphire"
}

ItsyScape.Meta.ResourceName {
	Value = "Sapphire",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Sapphire"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The most common of the common gems.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Sapphire"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(45),
	Resource = ItsyScape.Resource.Item "Sapphire"
}

ItsyScape.Resource.Item "Emerald" {
	ItsyScape.Action.ObtainSecondary() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForLevel(20)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForResource(20)
		},

		Output {
			Resource = ItsyScape.Resource.Item "Emerald",
			Count = 1
		}
	}
}

ItsyScape.Meta.SecondaryWeight {
	Weight = 15,
	Resource = ItsyScape.Resource.Item "Emerald"
}

ItsyScape.Meta.ResourceName {
	Value = "Emerald",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Emerald"
}

ItsyScape.Meta.ResourceDescription {
	Value = "One of the common gems, will only make the pettiest green with envy...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Emerald"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(50),
	Resource = ItsyScape.Resource.Item "Emerald"
}

ItsyScape.Resource.Item "Ruby" {
	ItsyScape.Action.ObtainSecondary() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForLevel(30)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForResource(30)
		},

		Output {
			Resource = ItsyScape.Resource.Item "Ruby",
			Count = 1
		}
	}
}

ItsyScape.Meta.SecondaryWeight {
	Weight = 10,
	Resource = ItsyScape.Resource.Item "Ruby"
}

ItsyScape.Meta.ResourceName {
	Value = "Ruby",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Ruby"
}

ItsyScape.Meta.ResourceDescription {
	Value = "One of the common gems.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Ruby"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(55),
	Resource = ItsyScape.Resource.Item "Ruby"
}

ItsyScape.Resource.Item "Diamond" {
	ItsyScape.Action.ObtainSecondary() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForLevel(40)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForResource(40)
		},

		Output {
			Resource = ItsyScape.Resource.Item "Diamond",
			Count = 1
		}
	}
}

ItsyScape.Meta.SecondaryWeight {
	Weight = 5,
	Resource = ItsyScape.Resource.Item "Diamond"
}

ItsyScape.Meta.ResourceName {
	Value = "Diamond",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Diamond"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The rarest of the common gems.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Diamond"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(60),
	Resource = ItsyScape.Resource.Item "Diamond"
}
