local M = include "Resources/Game/Maps/Test123/DB/Default.lua"

ItsyScape.Meta.ResourceName {
	Value = "Home Zombi",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "It's full of zombies.",
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
		ColorRed = 234,
		ColorGreen = 162,
		ColorBlue = 33,
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
		ColorRed = 81,
		ColorGreen = 16,
		ColorBlue = 117,
		NearDistance = 20,
		FarDistance = 60,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 5,
		PositionZ = 29,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Zombi"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 5,
		PositionZ = 31,
		Name = "Zombi",
		Map = M._MAP,
		Resource = M["Zombi"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Zombi"]
	}
end

M["LightSphere"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 6,
		PositionZ = 29,
		Name = "LightSphere",
		Map = M._MAP,
		Resource = M["LightSphere"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_LightSphere",
		MapObject = M["LightSphere"]
	}
end

M["Mirror1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 5,
		PositionZ = 29,
		Name = "Mirror1",
		Map = M._MAP,
		Resource = M["Mirror1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_Mirror",
		MapObject = M["Mirror1"]
	}
end

M["Mirror2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 5,
		PositionZ = 37,
		Name = "Mirror2",
		Map = M._MAP,
		Resource = M["Mirror2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_Mirror",
		MapObject = M["Mirror2"]
	}
end

M["Mirror3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 5,
		PositionZ = 37,
		Name = "Mirror3",
		Map = M._MAP,
		Resource = M["Mirror3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_Mirror",
		MapObject = M["Mirror3"]
	}
end

M["Mirror4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 5,
		PositionZ = 37,
		Name = "Mirror4",
		Map = M._MAP,
		Resource = M["Mirror4"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_Mirror",
		MapObject = M["Mirror4"]
	}
end
