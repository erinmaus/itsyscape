local M = include "Resources/Game/Maps/Sailing_RuinsOfRhysilk/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Sailing_RuinsOfRhysilk.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Ruins of Rh'ysilk",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Destroyed in a cataclysmic event that was the prelude to the gods being banished from the world.",
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
		ColorRed = 128,
		ColorGreen = 128,
		ColorBlue = 255,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.4,
		Resource = M["Light_Ambient"]
	}
end

M["Light_Sun"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Sun",
		Map = M._MAP,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "DirectionalLight_Default",
		MapObject = M["Light_Sun"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 66,
		ColorGreen = 66,
		ColorBlue = 132,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 5,
		DirectionZ = 4,
		Resource = M["Light_Sun"]
	}
end

M["Light_Fog1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Fog1",
		Map = M._MAP,
		Resource = M["Light_Fog1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Fog_Default",
		MapObject = M["Light_Fog1"]
	}

	ItsyScape.Meta.Fog {
		ColorRed = 33,
		ColorGreen = 33,
		ColorBlue = 33,
		NearDistance = 20,
		FarDistance = 40,
		FollowTarget = 1,
		Resource = M["Light_Fog1"]
	}
end

M["Light_Fog2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Fog2",
		Map = M._MAP,
		Resource = M["Light_Fog2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Fog_Default",
		MapObject = M["Light_Fog2"]
	}

	ItsyScape.Meta.Fog {
		ColorRed = 83,
		ColorGreen = 103,
		ColorBlue = 108,
		NearDistance = 30,
		FarDistance = 60,
		Resource = M["Light_Fog2"]
	}
end

M["Light_Lightning"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Lightning",
		Map = M._MAP,
		Resource = M["Light_Lightning"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "AmbientLight_Default",
		MapObject = M["Light_Lightning"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Light_Lightning"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.0,
		Resource = M["Light_Lightning"]
	}
end

M["CastleLerper"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "CastleLerper",
		Map = M._MAP,
		Resource = M["CastleLerper"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "RuinsOfRhysilk_CastleLerper",
		MapObject = M["CastleLerper"]
	}
end

M["Anchor_BeachedShip"] = ItsyScape.Resource.MapObject.Unique()
do
	local Rotation1 = ItsyScape.Utility.Quaternion.fromAxisAngle(ItsyScape.Utility.Vector.UNIT_Y, math.pi / 4)
	local Rotation2 = ItsyScape.Utility.Quaternion.fromAxisAngle(ItsyScape.Utility.Vector.UNIT_X, math.pi / 3 - math.pi / 6)
	local Rotation3 = ItsyScape.Utility.Quaternion.fromAxisAngle(ItsyScape.Utility.Vector.UNIT_Z, math.pi / 32)
	local Rotation = Rotation1 * Rotation2 * Rotation3
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 7.5,
		PositionZ = 45,
		RotationX = Rotation.x,
		RotationY = Rotation.y,
		RotationZ = Rotation.z,
		RotationW = Rotation.w,
		Name = "Anchor_BeachedShip",
		Map = M._MAP,
		Resource = M["Anchor_BeachedShip"]
	}
end

M["Anchor_Ship"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 57,
		PositionY = 0,
		PositionZ = 107,
		Name = "Anchor_Ship",
		Map = M._MAP,
		Resource = M["Anchor_Ship"]
	}
end

M["Rowboat"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 51,
		PositionY = 1.25,
		PositionZ = 111,
		RotationX = ItsyScape.Utility.Quaternion.Y_90.x,
		RotationY = ItsyScape.Utility.Quaternion.Y_90.y,
		RotationZ = ItsyScape.Utility.Quaternion.Y_90.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_90.w,
		Name = "Rowboat",
		Map = M._MAP,
		Resource = M["Rowboat"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Rowboat_Default",
		MapObject = M["Rowboat"]
	}
end

M["Anchor_FirstMate"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 51,
		PositionY = 2,
		PositionZ = 107,
		Name = "Anchor_FirstMate",
		Map = M._MAP,
		Resource = M["Anchor_FirstMate"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 53,
		PositionY = 2,
		PositionZ = 107,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end
