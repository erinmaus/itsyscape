local M = include "Resources/Game/Maps/Dream_CalmBeforeTheStorm_ThroneRoom/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Dream_CalmBeforeTheStorm_ThroneRoom.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Dream Sequence",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "This dream takes place in Yendor's throne room.",
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
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.8,
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
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 3,
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
		ColorRed = 0,
		ColorGreen = 0,
		ColorBlue = 0,
		NearDistance = 5,
		FarDistance = 15,
		FollowTarget = 1,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 1,
		PositionZ = 61,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Yendor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 1,
		PositionZ = 17,
		Name = "Yendor",
		Map = M._MAP,
		Resource = M["Yendor"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendor",
		MapObject = M["Yendor"]
	}

	ItsyScape.Meta.PropAnchor {
		OffsetI = 0,
		OffsetJ = 8,
		Resource = M["Yendor"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Yendor"],
		Name = "Yendor",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Dream_CalmBeforeTheStorm_ThroneRoom/Dialog/Yendor_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["Yendor"] {
		TalkAction
	}
end

M["Maggot1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 1,
		PositionZ = 37,
		Name = "Maggot1",
		Map = M._MAP,
		Resource = M["Maggot1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CalmBeforeTheStorm_Maggot",
		MapObject = M["Maggot1"]
	}
end

M["Maggot2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 1,
		PositionZ = 39,
		Name = "Maggot2",
		Map = M._MAP,
		Resource = M["Maggot2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CalmBeforeTheStorm_Maggot",
		MapObject = M["Maggot2"]
	}
end

M["Maggot3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 1,
		PositionZ = 41,
		Name = "Maggot3",
		Map = M._MAP,
		Resource = M["Maggot3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CalmBeforeTheStorm_Maggot",
		MapObject = M["Maggot3"]
	}
end

M["Maggot4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 1,
		PositionZ = 37,
		Name = "Maggot4",
		Map = M._MAP,
		Resource = M["Maggot4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CalmBeforeTheStorm_Maggot",
		MapObject = M["Maggot4"]
	}
end

M["Maggot5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 1,
		PositionZ = 39,
		Name = "Maggot5",
		Map = M._MAP,
		Resource = M["Maggot5"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CalmBeforeTheStorm_Maggot",
		MapObject = M["Maggot5"]
	}
end

M["Maggot6"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 1,
		PositionZ = 41,
		Name = "Maggot6",
		Map = M._MAP,
		Resource = M["Maggot6"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CalmBeforeTheStorm_Maggot",
		MapObject = M["Maggot6"]
	}
end

M["Maggot7"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 1,
		PositionZ = 37,
		Name = "Maggot7",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Maggot7"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CalmBeforeTheStorm_Maggot",
		MapObject = M["Maggot7"]
	}
end

M["Maggot8"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 1,
		PositionZ = 39,
		Name = "Maggot8",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Maggot8"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CalmBeforeTheStorm_Maggot",
		MapObject = M["Maggot8"]
	}
end

M["Maggot9"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 1,
		PositionZ = 41,
		Name = "Maggot9",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Maggot9"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CalmBeforeTheStorm_Maggot",
		MapObject = M["Maggot9"]
	}
end



M["Maggot10"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41,
		PositionY = 1,
		PositionZ = 37,
		Name = "Maggot10",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Maggot10"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CalmBeforeTheStorm_Maggot",
		MapObject = M["Maggot10"]
	}
end

M["Maggot11"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41,
		PositionY = 1,
		PositionZ = 39,
		Name = "Maggot11",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Maggot11"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CalmBeforeTheStorm_Maggot",
		MapObject = M["Maggot11"]
	}
end

M["Maggot12"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41,
		PositionY = 1,
		PositionZ = 41,
		Name = "Maggot12",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Maggot12"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CalmBeforeTheStorm_Maggot",
		MapObject = M["Maggot12"]
	}
end
