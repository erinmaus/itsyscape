local M = include "Resources/Game/Maps/Rumbridge_Farm1/DB/Default.lua"

ItsyScape.Meta.ResourceName {
	Value = "Farm, Rumbridge",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "A kid might burn this place down with all those veggies around!",
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

M["Anchor_FromTownSouth"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 30,
		PositionY = 4,
		PositionZ = 58,
		Name = "Anchor_FromTownSouth",
		Map = M._MAP,
		Resource = M["Anchor_FromTownSouth"]
	}
end

M["Portal_RumbridgeTownSouth"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 30,
		PositionY = 4,
		PositionZ = 62,
		Name = "Portal_RumbridgeTownSouth",
		Map = M._MAP,
		Resource = M["Portal_RumbridgeTownSouth"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 4,
		SizeY = 2,
		SizeZ = 4,
		MapObject = M["Portal_RumbridgeTownSouth"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_RumbridgeTownSouth"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rumbridge Town, South",
		Language = "en-US",
		Resource = M["Portal_RumbridgeTownSouth"]
	}

	-- local TravelAction = ItsyScape.Action.Travel()

	-- ItsyScape.Meta.TravelDestination {
	-- 	Anchor = "Anchor_FromFarm1",
	-- 	Map = ItsyScape.Resource.Map "Rumbridge_Town_South",
	-- 	Action = TravelAction
	-- }

	-- ItsyScape.Meta.ActionVerb {
	-- 	Value = "Enter",
	-- 	XProgressive = "Entering",
	-- 	Language = "en-US",
	-- 	Action = TravelAction
	-- }

	M["Portal_RumbridgeTownSouth"] {
		--TravelAction
	}
end