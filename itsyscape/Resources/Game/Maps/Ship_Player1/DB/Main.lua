local M = include "Resources/Game/Maps/Ship_Player1/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Ship_Player1.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Player's Ship",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "A ship captained by none other than you.",
	Language = "en-US",
	Resource = M._MAP
}

M["Light_Lantern1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 4,
		PositionZ = 11,
		Name = "Light_Lantern1",
		Map = M._MAP,
		Resource = M["Light_Lantern1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_Lantern1"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 200,
		ColorGreen = 160,
		ColorBlue = 66,
		Resource = M["Light_Lantern1"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 16,
		Resource = M["Light_Lantern1"]
	}
end

M["Light_Lantern2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 13,
		PositionY = 4,
		PositionZ = 11,
		Name = "Light_Lantern2",
		Map = M._MAP,
		Resource = M["Light_Lantern2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_Lantern2"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 200,
		ColorGreen = 160,
		ColorBlue = 66,
		Resource = M["Light_Lantern2"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 16,
		Resource = M["Light_Lantern2"]
	}
end

M["Cannon1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15.000000,
		PositionY = 4.000000,
		PositionZ = 7.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Cannon1",
		Map = M._MAP,
		Resource = M["Cannon1"]
	}
end

M["Cannon2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25.000000,
		PositionY = 4.000000,
		PositionZ = 7.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Cannon2",
		Map = M._MAP,
		Resource = M["Cannon2"]
	}
end

M["Cannon3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15.000000,
		PositionY = 4.000000,
		PositionZ = 15.000000,
		RotationX = ItsyScape.Utility.Quaternion.Y_180.x,
		RotationY = ItsyScape.Utility.Quaternion.Y_180.y,
		RotationZ = ItsyScape.Utility.Quaternion.Y_180.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_180.w,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Cannon3",
		Map = M._MAP,
		Resource = M["Cannon3"]
	}
end

M["Cannon4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25.000000,
		PositionY = 4.000000,
		PositionZ = 15.000000,
		RotationX = ItsyScape.Utility.Quaternion.Y_180.x,
		RotationY = ItsyScape.Utility.Quaternion.Y_180.y,
		RotationZ = ItsyScape.Utility.Quaternion.Y_180.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_180.w,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Cannon4",
		Map = M._MAP,
		Resource = M["Cannon4"]
	}
end

M["Sail1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 13.000000,
		PositionY = 4.000000,
		PositionZ = 11.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Sail1",
		Map = M._MAP,
		Resource = M["Sail1"]
	}
end

M["Sail2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23.000000,
		PositionY = 4.000000,
		PositionZ = 11.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Sail2",
		Map = M._MAP,
		Resource = M["Sail2"]
	}
end

M["Helm"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27.000000,
		PositionY = 5.000000,
		PositionZ = 11.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Helm",
		Map = M._MAP,
		Resource = M["Helm"]
	}
end