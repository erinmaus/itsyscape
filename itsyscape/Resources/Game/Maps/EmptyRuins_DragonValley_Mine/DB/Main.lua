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

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 0,
		PositionZ = 33,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
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
		MapObject = M["Behemoth"]
	}
end

M["BarrelMimic"] = ItsyScape.Resource.MapObject.Unique()
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
		Name = "BarrelMimic",
		Map = M._MAP,
		Resource = M["BarrelMimic"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "BarrelMimic",
		MapObject = M["BarrelMimic"]
	}
end

M["CrateMimic"] = ItsyScape.Resource.MapObject.Unique()
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
		Name = "CrateMimic",
		Map = M._MAP,
		Resource = M["CrateMimic"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CrateMimic",
		MapObject = M["CrateMimic"]
	}
end
