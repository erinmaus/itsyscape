local M = include "Resources/Game/Maps/IsabelleIsland_Port/DB/Default.lua"

ItsyScape.Meta.ResourceName {
	Value = "Port Isabelle",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "A peaceful seaside abode named after a sweet egomaniac.",
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
		ColorRed = 33,
		ColorGreen = 162,
		ColorBlue = 234,
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
		ColorRed = 234,
		ColorGreen = 162,
		ColorBlue = 33,
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
		ColorGreen = 162,
		ColorBlue = 234,
		NearDistance = 50,
		FarDistance = 200,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_FromTower"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 10,
		PositionZ = 59,
		Name = "Anchor_FromTower",
		Map = M._MAP,
		Resource = M["Anchor_FromTower"]
	}
end

M["Portal_Tower"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 10,
		PositionZ = 63,
		Name = "Portal_Tower",
		Map = M._MAP,
		Resource = M["Portal_Tower"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 2,
		SizeY = 1,
		SizeZ = 4,
		MapObject = M["Portal_Tower"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_Tower"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Isabelle Tower",
		Language = "en-US",
		Resource = M["Portal_Tower"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_Port",
		Map = ItsyScape.Resource.Map "IsabelleIsland_Tower",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Enter",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_Tower"] {
		TravelAction
	}
end

M["RewardChest"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.000000,
		PositionY = 10.000000,
		PositionZ = 11.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "RewardChest",
		Map = M._MAP,
		Resource = M["RewardChest"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "IsabelleIsland_Port_RewardChest",
		MapObject = M["RewardChest"]
	}

	M["RewardChest"] {
		ItsyScape.Action.Collect()
	}
end

M["FishingStoreOwner"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 10,
		PositionZ = 15,
		Name = "FishingStoreOwner",
		Map = M._MAP,
		Resource = M["FishingStoreOwner"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "FishingStoreOwner_Standard",
		MapObject = M["FishingStoreOwner"]
	}
end

M["FishingTutor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 50,
		PositionY = 10,
		PositionZ = 27,
		Direction = -1,
		Name = "FishingTutor",
		Map = M._MAP,
		Resource = M["FishingTutor"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["FishingTutor"],
		Name = "Fisherman",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_Port/Dialog/Fisherman_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Fisherman",
		MapObject = M["FishingTutor"]
	}

	M["FishingTutor"] {
		TalkAction
	}
end

do
	M["Chest_Default2"] {
		ItsyScape.Action.Bank()
	}
end

M["Jenkins"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 10,
		PositionZ = 35,
		Direction = -1,
		Name = "Jenkins",
		Map = M._MAP,
		Resource = M["Jenkins"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Jenkins"],
		Name = "Jenkins",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_Port/Dialog/PortmasterJenkins_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins",
		MapObject = M["Jenkins"]
	}

	M["Jenkins"] {
		TalkAction
	}
end

M["Anchor_ReturnFromSea"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 10,
		PositionZ = 37,
		Name = "Anchor_ReturnFromSea",
		Map = M._MAP,
		Resource = M["Anchor_ReturnFromSea"]
	}
end

M["Anchor_FromHighChambersYendor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 55,
		PositionY = 10,
		PositionZ = 35,
		Name = "Anchor_FromHighChambersYendor",
		Map = M._MAP,
		Resource = M["Anchor_FromHighChambersYendor"]
	}
end

M["TrapDoor_ToHighChambersYendor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 55,
		PositionY = 10,
		PositionZ = 33,
		Name = "TrapDoor_ToHighChambersYendor",
		Map = M._MAP,
		Resource = M["TrapDoor_ToHighChambersYendor"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "TrapDoor_Default",
		MapObject = M["TrapDoor_ToHighChambersYendor"]
	}

	local TravelAction = ItsyScape.Action.Travel() {
		Requirement {
			Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_OpenedHighChambersYendor",
			Count = 1
		}
	}

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromPort",
		Map = ItsyScape.Resource.Map "HighChambersYendor_Floor1West",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Descend",
		Language = "en-US",
		Action = TravelAction
	}

	M["TrapDoor_ToHighChambersYendor"] {
		TravelAction
	}
end
