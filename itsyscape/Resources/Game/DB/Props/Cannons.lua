--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Cannons.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "IronCannonball" {
	ItsyScape.Action.Smith() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForLevel(15)
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Hammer",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "IronBar",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "IronCannonball",
			Count = 5
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForResource(15)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Iron cannonball",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IronCannonball"
}

ItsyScape.Meta.ResourceDescription {
	Value = "What's heavier, a ton of iron cannoballs or a ton of feathers?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IronCannonball"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(11),
	Weight = 0,
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "IronCannonball"
}

ItsyScape.Meta.ResourceCategory {
	Key = "Metal",
	Value = "Iron",
	Resource = ItsyScape.Resource.Item "IronCannonball"
}

ItsyScape.Resource.Prop "Sailing_IronCannon_Default" {
	ItsyScape.Action.Fire() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Strength",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Input {
			Resource = ItsyScape.Resource.Item "IronCannonball",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForResource(2)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Strength",
			Count = ItsyScape.Utility.xpForResource(2)
		}
	}
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicCannon",
	Resource = ItsyScape.Resource.Prop "Sailing_IronCannon_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 3,
	SizeZ = 1.5,
	OffsetZ = 1,
	MapObject = ItsyScape.Resource.Prop "Sailing_IronCannon_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Iron cannon",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Sailing_IronCannon_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "At least it's not made of bronze...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Sailing_IronCannon_Default"
}

ItsyScape.Meta.GatherableProp {
	Health = 5,
	SpawnTime = 5,
	Resource = ItsyScape.Resource.Prop "Sailing_IronCannon_Default"
}

ItsyScape.Meta.Cannon {
	Range = 10,
	MinDamage = 100,
	MaxDamage = 200,
	Cannonball = ItsyScape.Resource.Item "IronCannonball",
	Resource = ItsyScape.Resource.Prop "Sailing_IronCannon_Default"
}

ItsyScape.Resource.Prop "Sailing_Player_IronCannon" {
	ItsyScape.Action.Fire() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForLevel(5)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Strength",
			Count = ItsyScape.Utility.xpForLevel(5)
		},

		Input {
			Resource = ItsyScape.Resource.Item "IronCannonball",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForResource(2)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Strength",
			Count = ItsyScape.Utility.xpForResource(2)
		}
	}
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicCannon",
	Resource = ItsyScape.Resource.Prop "Sailing_Player_IronCannon"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 3,
	SizeZ = 1.5,
	OffsetZ = 1,
	MapObject = ItsyScape.Resource.Prop "Sailing_Player_IronCannon"
}

ItsyScape.Meta.ResourceName {
	Value = "Iron cannon",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Sailing_Player_IronCannon"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Shoddy workmanship, better hope it doesn't blow up in your face!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Sailing_Player_IronCannon"
}

ItsyScape.Meta.GatherableProp {
	Health = 10,
	SpawnTime = 10,
	Resource = ItsyScape.Resource.Prop "Sailing_Player_IronCannon"
}

ItsyScape.Meta.Cannon {
	Range = 10,
	MinDamage = 10,
	MaxDamage = 15,
	Cannonball = ItsyScape.Resource.Item "IronCannonball",
	Resource = ItsyScape.Resource.Prop "Sailing_Player_IronCannon"
}
