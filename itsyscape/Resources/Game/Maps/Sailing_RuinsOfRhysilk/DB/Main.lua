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
		NearDistance = 5,
		FarDistance = 10,
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
		PositionX = 20,
		PositionY = 1.5,
		PositionZ = 35,
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
		PositionX = 83,
		PositionY = 0,
		PositionZ = 111,
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

M["Anchor_FromTemple"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 57,
		PositionY = 8,
		PositionZ = 63,
		Name = "Anchor_FromTemple",
		Map = M._MAP,
		Resource = M["Anchor_FromTemple"]
	}
end

M["Portal_ToTemple"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 67,
		PositionY = 2.5,
		PositionZ = 63,
		Name = "Portal_ToTemple",
		Map = M._MAP,
		Resource = M["Portal_ToTemple"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 6,
		SizeY = 2,
		SizeZ = 6,
		MapObject = M["Portal_ToTemple"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_ToTemple"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Vast chasm",
		Language = "en-US",
		Resource = M["Portal_ToTemple"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Jump if you dare...",
		Language = "en-US",
		Resource = M["Portal_ToTemple"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromChasm",
		Map = ItsyScape.Resource.Map "Sailing_RuinsOfRhysilk_UndergroundTemple",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Jump",
		XProgressive = "Jumping",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_ToTemple"] {
		TravelAction
	}
end

M["UnstablePortal"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 57,
		PositionY = 8,
		PositionZ = 59,
		Name = "UnstablePortal",
		Map = M._MAP,
		Resource = M["UnstablePortal"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Portal_Default",
		MapObject = M["UnstablePortal"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Unstable portal",
		Language = "en-US",
		Resource = M["UnstablePortal"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The portal is unstable and can't be used.",
		Language = "en-US",
		Resource = M["UnstablePortal"]
	}
end

M["Yendorian1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 57,
		PositionY = 8,
		PositionZ = 61,
		Name = "Yendorian1",
		Map = M._MAP,
		Resource = M["Yendorian1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendorian_Ballista",
		MapObject = M["Yendorian1"]
	}
end

M["Yendorian2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 6,
		PositionZ = 91,
		Name = "Yendorian2",
		Map = M._MAP,
		Resource = M["Yendorian2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendorian_Mast",
		MapObject = M["Yendorian2"]
	}
end

M["Yendorian3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 75,
		PositionY = 4,
		PositionZ = 89,
		Name = "Yendorian3",
		Map = M._MAP,
		Resource = M["Yendorian3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendorian_Swordfish",
		MapObject = M["Yendorian3"]
	}
end

M["Pirate1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 5,
		PositionZ = 51,
		Name = "Pirate1",
		Map = M._MAP,
		Resource = M["Pirate1"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IronBlunderbuss",
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
		PositionX = 19,
		PositionY = 3,
		PositionZ = 57,
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
		PositionX = 31,
		PositionY = 4,
		PositionZ = 43,
		Name = "Pirate3",
		Map = M._MAP,
		Resource = M["Pirate3"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IronMusket",
		Count = 1,
		Resource = M["Pirate3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "RuinsOfRhysilk_Pirate",
		MapObject = M["Pirate3"]
	}
end

M["Pirate4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
		PositionY = 4,
		PositionZ = 61,
		Name = "Pirate4",
		Map = M._MAP,
		Resource = M["Pirate4"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IronPistol",
		Count = 1,
		Resource = M["Pirate4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "RuinsOfRhysilk_Pirate",
		MapObject = M["Pirate4"]
	}
end

M["Pirate5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 4,
		PositionZ = 71,
		Name = "Pirate5",
		Map = M._MAP,
		Resource = M["Pirate5"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IronGrenade",
		Count = math.huge,
		Resource = M["Pirate5"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "RuinsOfRhysilk_Pirate",
		MapObject = M["Pirate5"]
	}
end
