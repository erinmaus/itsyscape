local M = include "Resources/Game/Maps/Sailing_WhaleIsland/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Sailing_WhaleIsland.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Mysterious island",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "A mysterious island that Cap'n Raven keeps secret.",
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

M["Anchor_Ship"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47,
		PositionY = -0.25,
		PositionZ = 17,
		RotationX = ItsyScape.Utility.Quaternion.Y_90.x,
		RotationY = ItsyScape.Utility.Quaternion.Y_90.y,
		RotationZ = ItsyScape.Utility.Quaternion.Y_90.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_90.w,
		Name = "Anchor_Ship",
		Map = M._MAP,
		Resource = M["Anchor_Ship"]
	}
end

M["Rowboat"] = ItsyScape.Resource.MapObject.Unique()
do
	local rotation = ItsyScape.Utility.Quaternion.fromAxisAngle(
		ItsyScape.Utility.Vector.UNIT_Y,
		-math.pi / 4)

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 0.75,
		PositionZ = 31,
		RotationX = rotation.x,
		RotationY = rotation.y,
		RotationZ = rotation.z,
		RotationW = rotation.w,
		Name = "Rowboat",
		Map = M._MAP,
		Resource = M["Rowboat"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Rowboat_Default",
		MapObject = M["Rowboat"]
	}
end

M["CapnRaven"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 5,
		PositionZ = 21,
		Direction = 1,
		Name = "CapnRaven",
		Map = M._MAP,
		Resource = M["CapnRaven"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CapnRaven",
		MapObject = M["CapnRaven"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["CapnRaven"],
		Name = "CapnRaven",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "Lyra",
		Name = "Lyra",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "Oliver",
		Name = "Oliver",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Sailing_WhaleIsland/Dialog/CapnRaven_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["CapnRaven"] {
		TalkAction
	}
end

M["Oliver"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Oliver",
		Map = M._MAP,
		Resource = M["Oliver"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Oliver",
		MapObject = M["Oliver"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Rumbridge_Town_Center_South/Scripts/Oliver_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Oliver"]
	}

	M["Oliver"] {
		ItsyScape.Action.Pet()
	}
end

M["Lyra"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Lyra",
		Map = M._MAP,
		Resource = M["Lyra"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Lyra",
		MapObject = M["Lyra"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Lyra"],
		Name = "Lyra",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Oliver"],
		Name = "Oliver",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Rumbridge_Town_Center_South/Dialog/Lyra_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["Lyra"] {
		TalkAction
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 1,
		PositionZ = 23,
		Direction = -1,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["BeachedWhale"] = ItsyScape.Resource.MapObject.Unique()
do
	local RotationY = ItsyScape.Utility.Quaternion.fromAxisAngle(ItsyScape.Utility.Vector.UNIT_Y, -math.pi / 3)
	local RotationZ = ItsyScape.Utility.Quaternion.fromAxisAngle(ItsyScape.Utility.Vector.UNIT_Z, math.pi / 4)
	local Rotation = RotationY * RotationZ

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 4,
		PositionZ = 35,
		RotationX = Rotation.x,
		RotationY = Rotation.y,
		RotationZ = Rotation.z,
		RotationW = Rotation.w,
		Name = "BeachedWhale",
		Map = M._MAP,
		Resource = M["BeachedWhale"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "Lyra",
		Name = "Lyra",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["BeachedWhale"],
		Name = "Whale",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Sailing_WhaleIsland/Dialog/Whale_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Desecrate",
		XProgressive = "Desecrating",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "UndeadWhale",
		MapObject = M["BeachedWhale"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	M["BeachedWhale"] {
		TalkAction
	}
end

M["Whale"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 0,
		PositionZ = 39,
		Name = "Whale",
		Map = M._MAP,
		Resource = M["Whale"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "UndeadWhale",
		MapObject = M["Whale"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "follow",
		Tree = "Resources/Game/Maps/Sailing_WhaleIsland/Scripts/Whale_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Whale"]
	}
end

M["Pirate1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19,
		PositionY = 4,
		PositionZ = 17,
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

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_WhaleIsland/Scripts/Pirate_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Pirate1"]
	}
end

M["Pirate2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 9,
		PositionY = 4,
		PositionZ = 13,
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

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_WhaleIsland/Scripts/Pirate_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Pirate2"]
	}
end

M["Pirate3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 2,
		PositionZ = 11,
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

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_WhaleIsland/Scripts/Pirate_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Pirate3"]
	}
end
