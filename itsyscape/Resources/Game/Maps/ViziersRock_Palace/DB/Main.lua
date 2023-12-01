local M = include "Resources/Game/Maps/ViziersRock_Palace/DB/Default.lua"

ItsyScape.Meta.ResourceName {
	Value = "Vizier's Rock, Palace",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Home to Vizier-King Yohn and his court.",
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
		ColorRed = 55,
		ColorGreen = 55,
		ColorBlue = 200,
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
		ColorRed = 111,
		ColorGreen = 124,
		ColorBlue = 145,
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
		ColorRed = 89,
		ColorGreen = 89,
		ColorBlue = 120,
		NearDistance = 15,
		FarDistance = 25,
		FollowTarget = 1,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_FromTown"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 32,
		PositionY = 0,
		PositionZ = 89,
		Name = "Anchor_FromTown",
		Map = M._MAP,
		Resource = M["Anchor_FromTown"]
	}
end

M["Portal_ToTown"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 32,
		PositionY = 0,
		PositionZ = 93,
		Name = "Portal_ToTown",
		Map = M._MAP,
		Resource = M["Portal_ToTown"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 3.5,
		SizeY = 2,
		SizeZ = 3.5,
		MapObject = M["Portal_ToTown"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_ToTown"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Vizier's Rock City Center",
		Language = "en-US",
		Resource = M["Portal_ToTown"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromPalace",
		Map = ItsyScape.Resource.Map "ViziersRock_Town_Center",
		Action = TravelAction
	}

	M["Portal_ToTown"] {
		TravelAction
	}
end

M["Chandelier"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47,
		PositionY = 5,
		PositionZ = 34,
		Name = "Chandelier",
		Map = M._MAP,
		Resource = M["Chandelier"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Chandelier_Default",
		MapObject = M["Chandelier"]
	}
end

M["Light_Chandlier"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47,
		PositionY = 5,
		PositionZ = 34,
		Name = "Light_Chandlier",
		Map = M._MAP,
		Resource = M["Light_Chandlier"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_Chandlier"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 128,
		ColorGreen = 128,
		ColorBlue = 255,
		Resource = M["Light_Chandlier"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 20,
		Resource = M["Light_Chandlier"]
	}
end

M["Light_Throne"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 1,
		PositionZ = 34,
		Name = "Light_Throne",
		Map = M._MAP,
		Resource = M["Light_Throne"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_Throne"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Light_Throne"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 8,
		Resource = M["Light_Throne"]
	}
end


M["King"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 1,
		PositionZ = 34,
		Name = "King",
		Map = M._MAP,
		Resource = M["King"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "VizierKingYohn",
		MapObject = M["King"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "Knight_ViziersRock",
		Name = "Knight",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["King"],
		Name = "Yohn",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/ViziersRock_Palace/Dialog/VizierKingYohn_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["King"] {
		TalkAction
	}
end

M["Guard1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 0,
		PositionZ = 79,
		Name = "Guard1",
		Map = M._MAP,
		Resource = M["Guard1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Guard_ViziersRock",
		MapObject = M["Guard1"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlackenedIronZweihander",
		Count = 1,
		Resource = M["Guard1"]
	}
end

M["Guard2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 0,
		PositionZ = 79,
		Name = "Guard2",
		Map = M._MAP,
		Resource = M["Guard2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Guard_ViziersRock",
		MapObject = M["Guard2"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlackenedIronMace",
		Count = 1,
		Resource = M["Guard2"]
	}
end

M["Guard3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 0,
		PositionZ = 61,
		Name = "Guard3",
		Map = M._MAP,
		Resource = M["Guard3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Guard_ViziersRock",
		MapObject = M["Guard3"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "PettyLongbow",
		Count = 1,
		Resource = M["Guard3"]
	}
end

M["Guard4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 3,
		PositionY = 0,
		PositionZ = 51,
		Name = "Guard4",
		Map = M._MAP,
		Resource = M["Guard4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Guard_ViziersRock",
		MapObject = M["Guard4"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "PettyBow",
		Count = 1,
		Resource = M["Guard4"]
	}
end

M["Guard5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 10,
		PositionY = 0,
		PositionZ = 39,
		Name = "Guard5",
		Map = M._MAP,
		Resource = M["Guard5"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Guard_ViziersRock",
		MapObject = M["Guard5"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlackenedIronDagger",
		Count = 1,
		Resource = M["Guard5"]
	}
end

M["Knight1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 1,
		PositionZ = 29,
		Name = "Knight1",
		Map = M._MAP,
		Resource = M["Knight1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Knight_ViziersRock",
		MapObject = M["Knight1"]
	}
end

M["Knight2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 1,
		PositionZ = 39,
		Name = "Knight2",
		Map = M._MAP,
		Resource = M["Knight2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Knight_ViziersRock",
		MapObject = M["Knight2"]
	}
end

M["Knight3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 9,
		PositionY = 0,
		PositionZ = 59,
		Name = "Knight3",
		Map = M._MAP,
		Resource = M["Knight3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Knight_ViziersRock",
		MapObject = M["Knight3"]
	}
end

M["Anchor_FromDungeon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 9,
		PositionY = 0,
		PositionZ = 51,
		Name = "Anchor_FromDungeon",
		Map = M._MAP,
		Resource = M["Anchor_FromDungeon"]
	}
end

M["TrapDoor_ToDungeon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 9,
		PositionY = 0,
		PositionZ = 49,
		Name = "TrapDoor_ToDungeon",
		Map = M._MAP,
		Resource = M["TrapDoor_ToDungeon"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "TrapDoor_Default",
		MapObject = M["TrapDoor_ToDungeon"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromPalace",
		Map = ItsyScape.Resource.Map "ViziersRock_Palace_Dungeon",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Descend",
		XProgressive = "Descending",
		Language = "en-US",
		Action = TravelAction
	}

	M["TrapDoor_ToDungeon"] {
		TravelAction
	}
end
