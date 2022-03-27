local M = include "Resources/Game/Maps/Rumbridge_Castle_CaveFloor1/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Rumbridge_Castle_CaveFloor1.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Deep Cave, Rumbridge",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "A fiery cave just underneath Rumbridge Castle.",
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
		ColorGreen = 150,
		ColorBlue = 150,
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
		ColorRed = 255,
		ColorGreen = 150,
		ColorBlue = 150,
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
		ColorRed = 235,
		ColorGreen = 30,
		ColorBlue = 30,
		NearDistance = 20,
		FarDistance = 40,
		FollowTarget = 1,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_FromDungeon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 9,
		PositionY = 2,
		PositionZ = 11,
		Name = "Anchor_FromDungeon",
		Map = M._MAP,
		Resource = M["Anchor_FromDungeon"]
	}
end

M["Ladder_ToDungeon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 9,
		PositionY = 2,
		PositionZ = 9,
		Name = "Ladder_ToDungeon",
		Map = M._MAP,
		Resource = M["Ladder_ToDungeon"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["Ladder_ToDungeon"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromCave",
		Map = ItsyScape.Resource.Map "Rumbridge_Castle_Dungeon",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_ToDungeon"] {
		TravelAction
	}
end

M["Anchor_Debug_VsShrimp"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 2,
		PositionZ = 31,
		Name = "Anchor_Debug_VsShrimp",
		Map = M._MAP,
		Resource = M["Anchor_Debug_VsShrimp"]
	}
end

M["Anchor_Debug_MagmaJellyfishTarget"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 2,
		PositionZ = 15,
		Name = "Anchor_Debug_MagmaJellyfishTarget",
		Map = M._MAP,
		Resource = M["Anchor_Debug_MagmaJellyfishTarget"]
	}
end

M["SaberToothShrimp"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 0,
		PositionZ = 27,
		Name = "SaberToothShrimp",
		Map = M._MAP,
		Resource = M["SaberToothShrimp"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "SaberToothShrimp",
		MapObject = M["SaberToothShrimp"]
	}
end

M["MagmaSnail1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 2,
		PositionZ = 17,
		Name = "MagmaSnail1",
		Map = M._MAP,
		Resource = M["MagmaSnail1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "MagmaSnail",
		MapObject = M["MagmaSnail1"]
	}
end

M["MagmaSnail2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 2,
		PositionZ = 15,
		Name = "MagmaSnail2",
		Map = M._MAP,
		Resource = M["MagmaSnail2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "MagmaSnail",
		MapObject = M["MagmaSnail2"]
	}
end

M["MagmaSnail3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 2,
		PositionZ = 39,
		Name = "MagmaSnail3",
		Map = M._MAP,
		Resource = M["MagmaSnail3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "MagmaSnail",
		MapObject = M["MagmaSnail3"]
	}
end

M["MagmaSnail4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21,
		PositionY = 2,
		PositionZ = 51,
		Name = "MagmaSnail4",
		Map = M._MAP,
		Resource = M["MagmaSnail4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "MagmaSnail",
		MapObject = M["MagmaSnail4"]
	}
end

M["MagmaSnail5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 2,
		PositionZ = 43,
		Name = "MagmaSnail5",
		Map = M._MAP,
		Resource = M["MagmaSnail5"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "MagmaSnail",
		MapObject = M["MagmaSnail5"]
	}
end

M["MagmaSnail6"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 53,
		PositionY = 2,
		PositionZ = 49,
		Name = "MagmaSnail6",
		Map = M._MAP,
		Resource = M["MagmaSnail6"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "MagmaSnail",
		MapObject = M["MagmaSnail6"]
	}
end

M["MagmaJellyfish1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 53,
		PositionY = 2,
		PositionZ = 49,
		Name = "MagmaJellyfish1",
		Map = M._MAP,
		Resource = M["MagmaJellyfish1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "MagmaJellyfish",
		MapObject = M["MagmaJellyfish1"]
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "Rumbridge_Castle_CaveFloor1_Debug"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Shrimp",
		Cutscene = Cutscene,
		Resource = M["SaberToothShrimp"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "MagmaJellyfish",
		Cutscene = Cutscene,
		Resource = M["MagmaJellyfish1"]
	}
end
