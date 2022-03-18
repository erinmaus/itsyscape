local M = include "Resources/Game/Maps/Rumbridge_Town_Center/DB/Default.lua"

ItsyScape.Meta.ResourceName {
	Value = "Rumbridge City Center",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Lots of shops, not enough time!",
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

M["Anchor_FromPort"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 36,
		PositionY = 4,
		PositionZ = 1,
		Name = "Anchor_FromPort",
		Map = M._MAP,
		Resource = M["Anchor_FromPort"]
	}
end

M["Portal_ToPort"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 36,
		PositionY = 4,
		PositionZ = 1,
		Name = "Portal_ToPort",
		Map = M._MAP,
		Resource = M["Portal_ToPort"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 6,
		SizeY = 2,
		SizeZ = 2,
		MapObject = M["Portal_ToPort"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_ToPort"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rumbridge Port",
		Language = "en-US",
		Resource = M["Portal_ToPort"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromTown",
		Map = ItsyScape.Resource.Map "Rumbridge_Port",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Enter",
		XProgressive = "Entering",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_ToPort"] {
		TravelAction
	}
end

M["Anchor_FromTown"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 30,
		PositionY = 4,
		PositionZ = 63,
		Name = "Anchor_FromTown",
		Map = M._MAP,
		Resource = M["Anchor_FromTown"]
	}
end
