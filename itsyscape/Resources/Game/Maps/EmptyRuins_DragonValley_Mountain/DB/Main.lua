local M = include "Resources/Game/Maps/EmptyRuins_DragonValley_Mountain/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.EmptyRuins_DragonValley_Mountain.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Mt. Vazikerl",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "The mountain the separates the Realm from The Empty Ruins, guarded by the enraged dragon Svalbard at its peak...",
	Language = "en-US",
	Resource = M._MAP
}

M["Light_Ambient"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 224,
		PositionY = 244,
		PositionZ = 242,
		Name = "Light_Ambient",
		Map = M._MAP,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "AmbientLight_Default",
		MapObject = M["Light_Ambient"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 231,
		ColorGreen = 168,
		ColorBlue = 194,
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
		ColorRed = 206,
		ColorGreen = 232,
		ColorBlue = 233,
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
		ColorRed = 206,
		ColorGreen = 232,
		ColorBlue = 233,
		NearDistance = 10,
		FarDistance = 25,
		FollowTarget = 1,
		Resource = M["Light_Fog"]
	}
end

M["Entrance_ToPeak"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 33,
		PositionZ = 6,
		Name = "Entrance_ToPeak",
		Map = M._MAP,
		Resource = M["Entrance_ToPeak"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_Entrance",
		MapObject = M["Entrance_ToPeak"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Mt. Vazikerl peak",
		Language = "en-US",
		Resource = M["Entrance_ToPeak"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Enter if you dare...",
		Language = "en-US",
		Resource = M["Entrance_ToPeak"]
	}
end

M["Entrance_ToMines"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 18,
		PositionY = 3,
		PositionZ = 84,
		Name = "Entrance_ToMines",
		Map = M._MAP,
		Resource = M["Entrance_ToMines"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_Entrance",
		MapObject = M["Entrance_ToMines"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Mt. Vazikerl mines",
		Language = "en-US",
		Resource = M["Entrance_ToMines"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Out of one frying pan, into another... Let's go back!",
		Language = "en-US",
		Resource = M["Entrance_ToMines"]
	}
end

M["Anchor_FromMines"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 18,
		PositionY = 3,
		PositionZ = 87,
		Name = "Anchor_FromMines",
		Map = M._MAP,
		Resource = M["Anchor_FromMines"]
	}
end

M["Anchor_FromPeak"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 33,
		PositionZ = 9,
		Name = "Anchor_FromPeak",
		Map = M._MAP,
		Resource = M["Anchor_FromPeak"]
	}
end

M["Anchor_Bridge"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 57,
		PositionY = 23,
		PositionZ = 37,
		Name = "Anchor_Bridge",
		Map = M._MAP,
		Resource = M["Anchor_Bridge"]
	}
end