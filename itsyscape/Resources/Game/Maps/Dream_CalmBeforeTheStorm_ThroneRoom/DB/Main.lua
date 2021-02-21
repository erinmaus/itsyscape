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
	Value = "This dream takes place in the Empty King's throne room.",
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
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
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

M["TheEmptyKing"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 1,
		PositionZ = 33,
		Name = "TheEmptyKing",
		Map = M._MAP,
		Resource = M["TheEmptyKing"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "TheEmptyKing_Cutscene",
		MapObject = M["TheEmptyKing"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "TheEmptyKing_Cutscene",
		Name = "TheEmptyKing",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Dream_CalmBeforeTheStorm_ThroneRoom/Dialog/TheEmptyKing_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["TheEmptyKing"] {
		TalkAction
	}
end

M["EmptyZealot1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 1,
		PositionZ = 37,
		Name = "EmptyZealot1",
		Map = M._MAP,
		Resource = M["EmptyZealot1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "EmptyZealot_Cutscene",
		MapObject = M["EmptyZealot1"]
	}
end

M["EmptyZealot2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 1,
		PositionZ = 39,
		Name = "EmptyZealot2",
		Map = M._MAP,
		Resource = M["EmptyZealot2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "EmptyZealot_Cutscene",
		MapObject = M["EmptyZealot2"]
	}
end

M["EmptyZealot3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 1,
		PositionZ = 41,
		Name = "EmptyZealot3",
		Map = M._MAP,
		Resource = M["EmptyZealot3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "EmptyZealot_Cutscene",
		MapObject = M["EmptyZealot3"]
	}
end



M["EmptyZealot4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 1,
		PositionZ = 37,
		Name = "EmptyZealot4",
		Map = M._MAP,
		Resource = M["EmptyZealot4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "EmptyZealot_Cutscene",
		MapObject = M["EmptyZealot4"]
	}
end

M["EmptyZealot5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 1,
		PositionZ = 39,
		Name = "EmptyZealot5",
		Map = M._MAP,
		Resource = M["EmptyZealot5"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "EmptyZealot_Cutscene",
		MapObject = M["EmptyZealot5"]
	}
end

M["EmptyZealot6"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 1,
		PositionZ = 41,
		Name = "EmptyZealot6",
		Map = M._MAP,
		Resource = M["EmptyZealot6"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "EmptyZealot_Cutscene",
		MapObject = M["EmptyZealot6"]
	}
end

M["EmptyZealot7"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 1,
		PositionZ = 37,
		Name = "EmptyZealot7",
		Direction = -1,
		Map = M._MAP,
		Resource = M["EmptyZealot7"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "EmptyZealot_Cutscene",
		MapObject = M["EmptyZealot7"]
	}
end

M["EmptyZealot8"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 1,
		PositionZ = 39,
		Name = "EmptyZealot8",
		Direction = -1,
		Map = M._MAP,
		Resource = M["EmptyZealot8"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "EmptyZealot_Cutscene",
		MapObject = M["EmptyZealot8"]
	}
end

M["EmptyZealot9"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 1,
		PositionZ = 41,
		Name = "EmptyZealot9",
		Direction = -1,
		Map = M._MAP,
		Resource = M["EmptyZealot9"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "EmptyZealot_Cutscene",
		MapObject = M["EmptyZealot9"]
	}
end



M["EmptyZealot10"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 1,
		PositionZ = 37,
		Name = "EmptyZealot10",
		Direction = -1,
		Map = M._MAP,
		Resource = M["EmptyZealot10"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "EmptyZealot_Cutscene",
		MapObject = M["EmptyZealot10"]
	}
end

M["EmptyZealot11"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 1,
		PositionZ = 39,
		Name = "EmptyZealot11",
		Direction = -1,
		Map = M._MAP,
		Resource = M["EmptyZealot11"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "EmptyZealot_Cutscene",
		MapObject = M["EmptyZealot11"]
	}
end

M["EmptyZealot12"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 1,
		PositionZ = 41,
		Name = "EmptyZealot12",
		Direction = -1,
		Map = M._MAP,
		Resource = M["EmptyZealot12"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "EmptyZealot_Cutscene",
		MapObject = M["EmptyZealot12"]
	}
end
