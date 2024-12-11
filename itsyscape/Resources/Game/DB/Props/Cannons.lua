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
	Value = "Resources.Game.Peeps.Props.Cannonball",
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

do
	local CannonballItem = ItsyScape.Resource.Item "ItsyCannonball"
	local CannonballProp = ItsyScape.Resource.Prop "Cannonball_Itsy"
	local CannonballSailingItem = ItsyScape.Resource.SailingItem "Cannonball_Itsy"

	ItsyScape.Meta.ResourceName {
		Value = "Itsy cannonball",
		Language = "en-US",
		Resource = CannonballItem
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A high-quality, incredibly heavy cannonball. This ball brings death and destruction too anything in its path.",
		Language = "en-US",
		Resource = CannonballItem
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Resource = CannonballItem
	}

	ItsyScape.Meta.ItemSailingItemMapping {
		Item = CannonballItem,
		SailingItem = CannonballSailingItem
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicCannonball",
		Resource = CannonballProp
	}

	ItsyScape.Meta.ResourceName {
		Value = "Itsy cannonball",
		Language = "en-US",
		Resource = CannonballProp
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Don't get hit by that, you're gonna die!",
		Language = "en-US",
		Resource = CannonballProp
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1,
		SizeY = 1,
		SizeZ = 1,
		MapObject = CannonballProp
	}

	ItsyScape.Meta.ResourceName {
		Value = "Itsy cannonball",
		Language = "en-US",
		Resource = CannonballSailingItem
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A high-quality, incredibly heavy cannonball. This ball brings death and destruction too anything in its path.",
		Language = "en-US",
		Resource = CannonballSailingItem
	}

	ItsyScape.Meta.SailingItemDetails {
		ItemGroup = "Cannonball",
		Resource = CannonballSailingItem
	}

	ItsyScape.Meta.ShipSailingItemPropHotspot {
		Slot = "Cannonball",
		ItemGroup = "Cannonball",
		Prop = CannonballProp,
		SailingItem = CannonballSailingItem
	}
end
