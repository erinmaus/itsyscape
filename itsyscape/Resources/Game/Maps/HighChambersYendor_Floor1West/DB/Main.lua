local M = include "Resources/Game/Maps/HighChambersYendor_Floor1West/DB/Default.lua"

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
		ColorRed = 124,
		ColorGreen = 111,
		ColorBlue = 145,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.6,
		Resource = M["Light_Ambient"]
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
		ColorRed = 90,
		ColorGreen = 44,
		ColorBlue = 160,
		NearDistance = 30,
		FarDistance = 60,
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
		ColorRed = 170,
		ColorGreen = 76,
		ColorBlue = 76,
		NearDistance = 50,
		FarDistance = 100,
		Resource = M["Light_Fog2"]
	}
end

M["Anchor_FromAbandonedMine"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 5,
		PositionY = 1,
		PositionZ = 99,
		Name = "Anchor_FromAbandonedMine",
		Map = M._MAP,
		Resource = M["Anchor_FromAbandonedMine"]
	}
end

M["Door_GuardianPrison"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 10,
		PositionY = 1,
		PositionZ = 72,
		Name = "Door_GuardianPrison",
		Map = M._MAP,
		Resource = M["Door_GuardianPrison"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor",
		MapObject = M["Door_GuardianPrison"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_GuardianPrison",
		MapObject = M["Door_GuardianPrison"]
	}
end

M["Door_MimicRoomNorth"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 8,
		PositionY = 1,
		PositionZ = 56,
		Name = "Door_MimicRoomNorth",
		Map = M._MAP,
		Resource = M["Door_MimicRoomNorth"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor",
		MapObject = M["Door_MimicRoomNorth"]
	}
end

M["Door_MimicRoomEast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 20,
		PositionY = 1,
		PositionZ = 64,
		RotationX = ItsyScape.Utility.Quaternion.Y_270.x,
		RotationY = ItsyScape.Utility.Quaternion.Y_270.y,
		RotationZ = ItsyScape.Utility.Quaternion.Y_270.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_270.w,
		Name = "Door_MimicRoomEast",
		Map = M._MAP,
		Resource = M["Door_MimicRoomEast"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor",
		MapObject = M["Door_MimicRoomEast"]
	}
end

M["Door_DoubleLockNorth"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 36,
		PositionY = 1,
		PositionZ = 52,
		Name = "Door_DoubleLockNorth",
		Map = M._MAP,
		Resource = M["Door_DoubleLockNorth"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor",
		MapObject = M["Door_DoubleLockNorth"]
	}
end

M["Door_DoubleLockWest"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 20,
		PositionY = 1,
		PositionZ = 42,
		RotationX = ItsyScape.Utility.Quaternion.Y_270.x,
		RotationY = ItsyScape.Utility.Quaternion.Y_270.y,
		RotationZ = ItsyScape.Utility.Quaternion.Y_270.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_270.w,
		Name = "Door_DoubleLockWest",
		Map = M._MAP,
		Resource = M["Door_DoubleLockWest"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor",
		MapObject = M["Door_DoubleLockWest"]
	}
end

M["Door_DoubleLockEast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 40,
		PositionY = 1,
		PositionZ = 36,
		RotationX = ItsyScape.Utility.Quaternion.Y_270.x,
		RotationY = ItsyScape.Utility.Quaternion.Y_270.y,
		RotationZ = ItsyScape.Utility.Quaternion.Y_270.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_270.w,
		Name = "Door_DoubleLockEast",
		Map = M._MAP,
		Resource = M["Door_DoubleLockEast"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Base",
		MapObject = M["Door_DoubleLockEast"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_DoubleLockEast",
		MapObject = M["Door_DoubleLockEast"]
	}
end

M["Door_WaterfallNorth"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 46,
		PositionY = -1,
		PositionZ = 50,
		Name = "Door_WaterfallNorth",
		Map = M._MAP,
		Resource = M["Door_WaterfallNorth"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor",
		MapObject = M["Door_WaterfallNorth"]
	}
end

M["Door_BeforeMinibossEntrance"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 102,
		PositionY = 1,
		PositionZ = 70,
		Name = "Door_BeforeMinibossEntrance",
		Map = M._MAP,
		Resource = M["Door_BeforeMinibossEntrance"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor",
		MapObject = M["Door_BeforeMinibossEntrance"]
	}
end

M["Door_MinibossEntrance"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 88,
		PositionY = 3,
		PositionZ = 82,
		RotationX = ItsyScape.Utility.Quaternion.Y_90.x,
		RotationY = ItsyScape.Utility.Quaternion.Y_90.y,
		RotationZ = ItsyScape.Utility.Quaternion.Y_90.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_90.w,
		Name = "Door_MinibossEntrance",
		Map = M._MAP,
		Resource = M["Door_MinibossEntrance"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor",
		MapObject = M["Door_MinibossEntrance"]
	}
end

M["Door_To2ndFloor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 110,
		PositionY = 1,
		PositionZ = 70,
		Name = "Door_To2ndFloor",
		Map = M._MAP,
		Resource = M["Door_To2ndFloor"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor",
		MapObject = M["Door_To2ndFloor"]
	}
end
