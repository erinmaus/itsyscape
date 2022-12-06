local M = include "Resources/Game/Maps/Rumbridge_Port/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Rumbridge_Port.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Rumbridge Port",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Home of the most drunken, pathetic sailors you've ever seen.",
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

M["Anchor_FromTown"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 5,
		PositionZ = 63,
		Name = "Anchor_FromTown",
		Map = M._MAP,
		Resource = M["Anchor_FromTown"]
	}
end

M["Portal_ToTown"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 36,
		PositionY = 5,
		PositionZ = 62,
		Name = "Portal_ToTown",
		Map = M._MAP,
		Resource = M["Portal_ToTown"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 4,
		SizeY = 2,
		SizeZ = 4,
		MapObject = M["Portal_ToTown"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_ToTown"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rumbridge Town Center",
		Language = "en-US",
		Resource = M["Portal_ToTown"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromPort",
		Map = ItsyScape.Resource.Map "Rumbridge_Town_Center",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Enter",
		XProgressive = "Entering",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_ToTown"] {
		TravelAction
	}
end

M["Anchor_FirstMateLocked"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 53,
		PositionY = 5,
		PositionZ = 53,
		Direction = -1,
		Name = "Anchor_FirstMateLocked",
		Map = M._MAP,
		Resource = M["Anchor_FirstMateLocked"]
	}
end

M["Anchor_FirstMateUnlocked"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 32.5,
		PositionY = 4,
		PositionZ = 28,
		Direction = -1,
		Name = "Anchor_FirstMateUnlocked",
		Map = M._MAP,
		Resource = M["Anchor_FirstMateUnlocked"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 4,
		PositionZ = 27,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Anchor_MapTable"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 57,
		PositionY = 5,
		PositionZ = 49,
		Name = "Anchor_MapTable",
		Map = M._MAP,
		Resource = M["Anchor_MapTable"]
	}
end

M["SeafarerGuildMaster"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 56,
		PositionY = 5,
		PositionZ = 47,
		Direction = -1,
		Name = "SeafarerGuildMaster",
		Map = M._MAP,
		Resource = M["SeafarerGuildMaster"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Rumbridge_Port_SeafarerGuildmaster",
		MapObject = M["SeafarerGuildMaster"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["SeafarerGuildMaster"],
		Name = "Robert",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Rumbridge_Port/Dialog/SeafarerGuildMasterRobert_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["SeafarerGuildMaster"] {
		TalkAction
	}
end

M["IsabelleIslandSailor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 4,
		PositionZ = 15,
		Name = "IsabelleIslandSailor",
		Map = M._MAP,
		Resource = M["IsabelleIslandSailor"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Sailor_Panicked",
		MapObject = M["IsabelleIslandSailor"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["IsabelleIslandSailor"],
		Name = "Sailor",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Rumbridge_Port/Dialog/IsabelleIslandSailor_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["IsabelleIslandSailor"] {
		TalkAction
	}
end
