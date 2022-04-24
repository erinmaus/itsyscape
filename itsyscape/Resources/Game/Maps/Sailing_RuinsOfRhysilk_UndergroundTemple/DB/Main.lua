local M = include "Resources/Game/Maps/Sailing_RuinsOfRhysilk_UndergroundTemple/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Sailing_RuinsOfRhysilk_UndergroundTemple.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Yendorian Temple, Ruins of Rh'ysilk",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "The horror of what lies below...",
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
		NearDistance = 20,
		FarDistance = 40,
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
		ColorRed = 0,
		ColorGreen = 0,
		ColorBlue = 0,
		NearDistance = 30,
		FarDistance = 60,
		Resource = M["Light_Fog2"]
	}
end

M["TempleLerper"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "TempleLerper",
		Map = M._MAP,
		Resource = M["TempleLerper"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "RuinsOfRhysilk_TempleLerper",
		MapObject = M["TempleLerper"]
	}
end

M["Door"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 24,
		PositionY = 2,
		PositionZ = 45,
		ScaleX = 3.33,
		ScaleY = 3.33,
		ScaleZ = 3.33,
		Name = "Door",
		Map = M._MAP,
		Resource = M["Door"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 25,
		SizeY = 10,
		SizeZ = 1,
		MapObject = M["Door"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Guardian",
		MapObject = M["Door"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_Temple",
		Map = M._MAP,
		MapObject = M["Door"]
	}
end

M["Anchor_FromChasm"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 24,
		PositionY = 30,
		PositionZ = 76,
		Name = "Anchor_FromChasm",
		Map = M._MAP,
		Resource = M["Anchor_FromChasm"]
	}
end

M["Yendor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 24,
		PositionY = 1,
		PositionZ = 26,
		Name = "Yendor",
		Map = M._MAP,
		Resource = M["Yendor"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendor_Base",
		MapObject = M["Yendor"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_Temple",
		Map = M._MAP,
		MapObject = M["Yendor"]
	}
end

M["Axe"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21,
		PositionY = 2,
		PositionZ = 25,
		ScaleX = 5,
		ScaleY = 5,
		ScaleZ = 5,
		Name = "Axe",
		Map = M._MAP,
		Resource = M["Axe"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "TheEmptyKingsExecutionerAxe",
		MapObject = M["Axe"]
	}
end

M["Maggot1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41,
		PositionY = 2,
		PositionZ = 25,
		Name = "Maggot1",
		Map = M._MAP,
		Resource = M["Maggot1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "RuinsOfRhysilk_Maggot",
		MapObject = M["Maggot1"]
	}
end

M["Maggot2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 9,
		PositionY = 2,
		PositionZ = 23,
		Name = "Maggot2",
		Map = M._MAP,
		Resource = M["Maggot2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "RuinsOfRhysilk_Maggot",
		MapObject = M["Maggot2"]
	}
end

M["Maggot3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 2,
		PositionZ = 9,
		Name = "Maggot3",
		Map = M._MAP,
		Resource = M["Maggot3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "RuinsOfRhysilk_Maggot",
		MapObject = M["Maggot3"]
	}
end

M["Maggot4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 2,
		PositionZ = 39,
		Name = "Maggot4",
		Map = M._MAP,
		Resource = M["Maggot4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "RuinsOfRhysilk_Maggot",
		MapObject = M["Maggot4"]
	}
end

M["Maggot5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 9,
		PositionY = 2,
		PositionZ = 35,
		Name = "Maggot5",
		Map = M._MAP,
		Resource = M["Maggot5"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "RuinsOfRhysilk_Maggot",
		MapObject = M["Maggot5"]
	}
end

M["Maggot6"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 2,
		PositionZ = 7,
		Name = "Maggot6",
		Map = M._MAP,
		Resource = M["Maggot6"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "RuinsOfRhysilk_Maggot",
		MapObject = M["Maggot6"]
	}
end

M["Exit"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 2,
		PositionZ = 6,
		Name = "Exit",
		Map = M._MAP,
		Resource = M["Exit"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Mysterious door",
		Language = "en-US",
		Resource = M["Exit"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Wonder where this leads... Hopefully out of here!",
		Language = "en-US",
		Resource = M["Exit"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_Entrance",
		MapObject = M["Exit"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_Fromtemple",
		Map = ItsyScape.Resource.Map "Sailing_RuinsOfRhysilk",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Enter",
		XProgressive = "Entering",
		Language = "en-US",
		Action = TravelAction
	}

	M["Exit"] {
		TravelAction
	}
end
