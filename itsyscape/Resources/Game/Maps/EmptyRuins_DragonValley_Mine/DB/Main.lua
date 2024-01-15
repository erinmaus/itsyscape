local M = include "Resources/Game/Maps/EmptyRuins_DragonValley_Mine/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.EmptyRuins_DragonValley_Mine.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Mines, Mt. Vazikerl",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "The Behemoth was trapped in the mines, causing earthquakes that devastate the surrounding area.",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.RaidGroup {
	Raid = ItsyScape.Resource.Raid "EmptyRuinsDragonValley",
	Map = M._MAP
}

M["Light_Ambient"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Ambient",
		Map = M._MAP,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "AmbientLight_Default",
		MapObject = M["Light_Ambient"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 173,
		ColorBlue = 119,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.4,
		Resource = M["Light_Ambient"]
	}
end

M["Light_Fog"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Fog",
		Map = M._MAP,
		Resource = M["Light_Fog"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Fog_Default",
		MapObject = M["Light_Fog"]
	}

	ItsyScape.Meta.Fog {
		ColorRed = 108,
		ColorGreen = 93,
		ColorBlue = 83,
		NearDistance = 40,
		FarDistance = 80,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_FromGinsville"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 0,
		PositionZ = 91,
		Name = "Anchor_FromGinsville",
		Map = M._MAP,
		Resource = M["Anchor_FromGinsville"]
	}
end

M["Portal_ToGinsville"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 0,
		PositionZ = 89,
		Name = "Portal_ToGinsville",
		Map = M._MAP,
		Resource = M["Portal_ToGinsville"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 3.5,
		SizeY = 2,
		SizeZ = 3.5,
		MapObject = M["Portal_ToGinsville"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_ToGinsville"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Old Ginsville",
		Language = "en-US",
		Resource = M["Portal_ToGinsville"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromMine",
		Map = ItsyScape.Resource.Map "EmptyRuins_DragonValley_Ginsville",
		Action = TravelAction
	}

	M["Portal_ToGinsville"] {
		TravelAction
	}
end

M["Behemoth"] = ItsyScape.Resource.MapObject.Unique()
do
	local rotation = ItsyScape.Utility.Quaternion.fromAxisAngle(ItsyScape.Utility.Vector.UNIT_Y, math.pi / 4)

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 0,
		PositionZ = 33,
		RotationX = rotation.x,
		RotationY = rotation.y,
		RotationZ = rotation.z,
		RotationW = rotation.w,
		Name = "Behemoth",
		Map = M._MAP,
		Resource = M["Behemoth"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Behemoth",
		MapObject = M["Behemoth"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}
end

M["ChestMimic"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "ChestMimic",
		Map = M._MAP,
		Resource = M["ChestMimic"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "ChestMimic",
		MapObject = M["ChestMimic"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/EmptyRuins_DragonValley_Mine/Scripts/Mimic_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["ChestMimic"]
	}
end

M["BarrelMimic"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "BarrelMimic",
		Map = M._MAP,
		Resource = M["BarrelMimic"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "BarrelMimic",
		MapObject = M["BarrelMimic"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/EmptyRuins_DragonValley_Mine/Scripts/Mimic_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["BarrelMimic"]
	}

	local BarrelMimicDropTable = ItsyScape.Resource.DropTable.Unique()

	local LootAction = ItsyScape.Action.Loot() {
		Output {
			Resource = BarrelMimicDropTable,
			Count = 1
		}
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "EmptyRuins_DragonValley_Barrel",
		Weight = 1,
		Count = 1,
		Resource = BarrelMimicDropTable
	}

	M["BarrelMimic"] {
		LootAction
	}
end

M["CrateMimic"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "CrateMimic",
		Map = M._MAP,
		Resource = M["CrateMimic"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CrateMimic",
		MapObject = M["CrateMimic"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/EmptyRuins_DragonValley_Mine/Scripts/Mimic_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["CrateMimic"]
	}
end

M["DustyChest"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 87,
		PositionY = 0,
		PositionZ = 7,
		Name = "DustyChest",
		Map = M._MAP,
		Resource = M["DustyChest"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Behemoth_Chest",
		MapObject = M["DustyChest"]
	}

	M["DustyChest"] {
		ItsyScape.Action.Collect(),
		ItsyScape.Action.Bank()
	}
end
