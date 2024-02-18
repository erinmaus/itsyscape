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
	},

	ItsyScape.Action.SailingUnlock() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Sailing",
			Count = ItsyScape.Utility.xpForLevel(1)
		}
	}
}

ItsyScape.Meta.CannonAmmo {
	AmmoType = ItsyScape.Utility.Equipment.AMMO_CANNONBALL,
	Resource = ItsyScape.Resource.Item "IronCannonball"
}

ItsyScape.Meta.Item {
	Weight = 0,
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "IronCannonball"
}

ItsyScape.Meta.Equipment {
	StrengthSailing = ItsyScape.Utility.strengthBonusForWeapon(10),
	Resource = ItsyScape.Resource.Item "IronCannonball"
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

ItsyScape.Resource.Item "StyrofoamCannonball" {
	ItsyScape.Action.SailingUnlock() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Sailing",
			Count = ItsyScape.Utility.xpForLevel(1)
		}
	}
}

ItsyScape.Meta.CannonAmmo {
	AmmoType = ItsyScape.Utility.Equipment.AMMO_CANNONBALL,
	Resource = ItsyScape.Resource.Item "StyrofoamCannonball"
}

ItsyScape.Meta.ResourceName {
	Value = "Styrofoam cannonball",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "StyrofoamCannonball"
}

ItsyScape.Meta.ResourceDescription {
	Value = "This will literally do no damage!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "StyrofoamCannonball"
}

ItsyScape.Meta.Item {
	Weight = 0,
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "StyrofoamCannonball"
}

ItsyScape.Meta.Equipment {
	StrengthSailing = -1000,
	Resource = ItsyScape.Resource.Item "StyrofoamCannonball"
}

ItsyScape.Resource.Prop "Sailing_IronCannon_Default" {
	ItsyScape.Action.Fire() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Sailing",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Sailing",
			Count = ItsyScape.Utility.xpForResource(2)
		}
	}
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicCannon",
	Resource = ItsyScape.Resource.Prop "Sailing_IronCannon_Default"
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
	Range = 24,
	AmmoType = ItsyScape.Utility.Equipment.AMMO_CANNONBALL,
	Resource = ItsyScape.Resource.Prop "Sailing_IronCannon_Default"
}

ItsyScape.Resource.Prop "Sailing_Player_IronCannon" {
	ItsyScape.Action.Fire() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Sailing",
			Count = ItsyScape.Utility.xpForLevel(1)
		}
	}
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicCannon",
	Resource = ItsyScape.Resource.Prop "Sailing_Player_IronCannon"
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
	Range = 24,
	Cannonball = ItsyScape.Resource.Item "IronCannonball",
	Resource = ItsyScape.Resource.Prop "Sailing_Player_IronCannon"
}

ItsyScape.Resource.Prop "IronCannonballPile" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.PassableProp",
	Resource = ItsyScape.Resource.Prop "IronCannonballPile"
}

ItsyScape.Meta.ResourceName {
	Value = "Iron cannonball pile",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "IronCannonballPile"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Go ahead! Grab some cannonballs!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "IronCannonballPile"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 1.5,
	SizeZ = 1.5,
	PanX = 0,
	PanY = 1,
	PanZ = 0,
	Zoom = 2.5,
	MapObject = ItsyScape.Resource.Prop "IronCannonballPile"
}
