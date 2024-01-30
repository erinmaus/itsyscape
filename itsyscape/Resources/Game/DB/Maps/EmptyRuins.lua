--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/EmptyRuins.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Raid = ItsyScape.Resource.Raid "EmptyRuinsDragonValley"

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Dragon Valley",
		Resource = ItsyScape.Resource.Raid "EmptyRuinsDragonValley"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Ascend Mt. Vazikerl and slay the undead dragon, Svalbard! On your way, you'll have to pass through the ruins of Old Ginsville and the mines, where horrifying monsters lurk...",
		Resource = ItsyScape.Resource.Raid "EmptyRuinsDragonValley"
	}

	ItsyScape.Meta.RaidDestination {
		Raid = Raid,
		Map = ItsyScape.Resource.Map "EmptyRuins_DragonValley_Ginsville",
		Anchor = "Anchor_Spawn"
	}
end

ItsyScape.Resource.Prop "Door_EmptyRuins" {
	ItsyScape.Action.Open(),
	ItsyScape.Action.Close()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicDoor",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins"
}

ItsyScape.Meta.ResourceName {
	Value = "Squeaky door",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 4,
	SizeZ = 0.5,
	MapObject = ItsyScape.Resource.Prop "Door_EmptyRuins"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Might be better to ignore what's behind that door...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins"
}

ItsyScape.Resource.Prop "Door_EmptyRuins_Single" {
	ItsyScape.Action.Open(),
	ItsyScape.Action.Close()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicDoor",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Single"
}

ItsyScape.Meta.ResourceName {
	Value = "Squeaky door",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Single"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 4,
	SizeZ = 0.5,
	MapObject = ItsyScape.Resource.Prop "Door_EmptyRuins_Single"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Probably don't wanna open that door...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Single"
}

ItsyScape.Resource.Prop "Door_EmptyRuins_Locked" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicGuardianDoor",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Locked"
}

ItsyScape.Meta.ResourceName {
	Value = "Squeaky door",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Locked"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 4,
	SizeZ = 0.5,
	MapObject = ItsyScape.Resource.Prop "Door_EmptyRuins_Locked"
}

ItsyScape.Meta.PropAlias {
	Alias = ItsyScape.Resource.Prop "Door_EmptyRuins",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Locked"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Might be better to ignore what's behind that door...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Locked"
}

ItsyScape.Resource.Prop "Door_EmptyRuins_Single_Locked" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicGuardianDoor",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Single_Locked"
}

ItsyScape.Meta.ResourceName {
	Value = "Squeaky door",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Single_Locked"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 4,
	SizeZ = 0.5,
	MapObject = ItsyScape.Resource.Prop "Door_EmptyRuins_Single_Locked"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Might be better to ignore what's behind that door...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Single_Locked"
}

ItsyScape.Meta.PropAlias {
	Alias = ItsyScape.Resource.Prop "Door_EmptyRuins_Single",
	Resource = ItsyScape.Resource.Prop "Door_EmptyRuins_Single_Locked"
}

do
	local RagingFire = ItsyScape.Resource.Prop "RagingFire"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.EmptyRuins.RagingFire",
		Resource = RagingFire
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 0,
		SizeY = 0,
		SizeZ = 0,
		MapObject = RagingFire
	}
end

do
	local Barrel = ItsyScape.Resource.Item "EmptyRuins_DragonValley_Barrel"

	local LightAction = ItsyScape.Action.Light() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForLevel(45)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Engineering",
			Count = ItsyScape.Utility.xpForLevel(45)
		},

		Input {
			Resource = Barrel,
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "HighYieldExplosiveOre",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForResource(45)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Engineering",
			Count = ItsyScape.Utility.xpForResource(45)
		}
	}

	Barrel {
		LightAction
	}

	ItsyScape.Meta.ActionSpawnProp {
		Prop = ItsyScape.Resource.Prop "EmptyRuins_DragonValley_Barrel",
		Action = LightAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Fill",
		XProgressive = "Filling",
		Language = "en-US",
		Action = LightAction
	}

	ItsyScape.Meta.ResourceName {
		Value = "Barrel mimic carcass",
		Language = "en-US",
		Resource = Barrel
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The carcass of a barrel mimic. Bet you can fill it with explosives... BOOM!",
		Language = "en-US",
		Resource = Barrel
	}
end

do
	local Barrel = ItsyScape.Resource.Prop "EmptyRuins_DragonValley_Barrel"

	ItsyScape.Meta.PropAlias {
		Alias = ItsyScape.Resource.Prop "Barrel_Default",
		Resource = Barrel
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.EmptyRuins.ExplosiveBarrel",
		Resource = Barrel
	}

	ItsyScape.Meta.ResourceName {
		Value = "Primed barrel",
		Language = "en-US",
		Resource = Barrel
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "This barrel is primed with high yield explosives and ready to blow! Watch out!",
		Language = "en-US",
		Resource = Barrel
	}
end

do
	local EmptyRuinsSkeletonWall = ItsyScape.Resource.Prop "EmptyRuinsSkeletonWall"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = EmptyRuinsSkeletonWall
	}
end

do
	local EmptyRuinsWallDecoration = ItsyScape.Resource.Prop "EmptyRuinsWallDecoration"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = EmptyRuinsWallDecoration
	}
end
