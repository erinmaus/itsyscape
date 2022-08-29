local M = include "Resources/Game/Maps/Trailer_Sailing/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Trailer_Sailing.Peep",
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
		Ambience = 0.6,
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
		ColorRed = 33,
		ColorGreen = 33,
		ColorBlue = 66,
		NearDistance = 20,
		FarDistance = 40,
		FollowTarget = 1,
		Resource = M["Light_Fog"]
	}
end

M["Pirate1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 6,
		PositionZ = 31,
		Name = "Pirate1",
		Map = M._MAP,
		Resource = M["Pirate1"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IronMusket",
		Count = 1,
		Resource = M["Pirate1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "RuinsOfRhysilk_Pirate",
		MapObject = M["Pirate1"]
	}
end


M["Pirate2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47,
		PositionY = 6,
		PositionZ = 27,
		Name = "Pirate2",
		Map = M._MAP,
		Resource = M["Pirate2"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IronPistol",
		Count = 1,
		Resource = M["Pirate2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "RuinsOfRhysilk_Pirate",
		MapObject = M["Pirate2"]
	}
end


M["Pirate3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 6,
		PositionZ = 27,
		Name = "Pirate3",
		Map = M._MAP,
		Resource = M["Pirate3"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IronGrenade",
		Count = 100000,
		Resource = M["Pirate3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "RuinsOfRhysilk_Pirate",
		MapObject = M["Pirate3"]
	}
end

M["Anchor_BeachedShip"] = ItsyScape.Resource.MapObject.Unique()
do
	local Rotation1 = ItsyScape.Utility.Quaternion.fromAxisAngle(ItsyScape.Utility.Vector.UNIT_Y, math.pi / 4)
	local Rotation2 = ItsyScape.Utility.Quaternion.fromAxisAngle(ItsyScape.Utility.Vector.UNIT_X, math.pi / 3 - math.pi / 6)
	local Rotation3 = ItsyScape.Utility.Quaternion.fromAxisAngle(ItsyScape.Utility.Vector.UNIT_Z, math.pi / 32)
	local Rotation = Rotation1 * Rotation2 * Rotation3
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 12,
		PositionY = 7.5,
		PositionZ = 4,
		RotationX = Rotation.x,
		RotationY = Rotation.y,
		RotationZ = Rotation.z,
		RotationW = Rotation.w,
		Name = "Anchor_BeachedShip",
		Map = M._MAP,
		Resource = M["Anchor_BeachedShip"]
	}
end
