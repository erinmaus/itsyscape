local M = include "Resources/Game/Maps/Rumbridge_Monastery/DB/Default.lua"

-- ItsyScape.Meta.PeepID {
-- 	Value = "Resources.Game.Maps.Rumbridge_Monastery.Peep",
-- 	Resource = M._MAP
-- }

ItsyScape.Meta.ResourceName {
	Value = "Rumbridge, Monastery",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "A place where monks make rum and the main bridge across the Rum River.",
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
		ColorRed = 231,
		ColorGreen = 168,
		ColorBlue = 194,
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
		ColorRed = 175,
		ColorGreen = 223,
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
		ColorRed = 33,
		ColorGreen = 162,
		ColorBlue = 234,
		NearDistance = 50,
		FarDistance = 200,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_FromCastle"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 24,
		PositionY = 4,
		PositionZ = 92,
		Name = "Anchor_FromCastle",
		Map = M._MAP,
		Resource = M["Anchor_FromCastle"]
	}
end

M["Anchor_FromViziersRock"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 24,
		PositionY = 4,
		PositionZ = 6,
		Name = "Anchor_FromViziersRock",
		Map = M._MAP,
		Resource = M["Anchor_FromViziersRock"]
	}
end

M["Portal_ToCastle"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 24,
		PositionY = 4,
		PositionZ = 92,
		Name = "Portal_ToCastle",
		Map = M._MAP,
		Resource = M["Portal_ToCastle"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 6,
		SizeY = 2,
		SizeZ = 6,
		MapObject = M["Portal_ToCastle"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_ToCastle"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rumbridge Castle",
		Language = "en-US",
		Resource = M["Portal_ToCastle"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromMonastery",
		Map = ItsyScape.Resource.Map "Rumbridge_Castle",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Enter",
		XProgressive = "Entering",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_ToCastle"] {
		TravelAction
	}
end

M["Portal_ToViziersRock"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 24,
		PositionY = 4,
		PositionZ = 2,
		Name = "Portal_ToViziersRock",
		Map = M._MAP,
		Resource = M["Portal_ToViziersRock"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 4,
		SizeY = 2,
		SizeZ = 4,
		MapObject = M["Portal_ToViziersRock"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_ToViziersRock"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Vizier's Rock",
		Language = "en-US",
		Resource = M["Portal_ToViziersRock"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromRumbridge",
		Map = ItsyScape.Resource.Map "ViziersRock_Town_Center",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Enter",
		XProgressive = "Entering",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_ToViziersRock"] {
		TravelAction
	}
end
