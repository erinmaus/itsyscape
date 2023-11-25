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
		PositionX = 31,
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
		PositionX = 31,
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
		ColorRed = 200,
		ColorGreen = 200,
		ColorBlue = 255,
		Resource = M["Light_Chandlier"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 40,
		Resource = M["Light_Chandlier"]
	}
end
