local M = include "Resources/Game/Maps/PreTutorial_Mansion/DB/Default.lua"

ItsyScape.Meta.ResourceName {
	Value = "Azathoth, Haunted Mansion South of Woodston",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "A mansion haunted by two children.",
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
		ColorRed = 101,
		ColorGreen = 139,
		ColorBlue = 131,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.9,
		Resource = M["Light_Ambient"]
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
		ColorRed = 91,
		ColorGreen = 119,
		ColorBlue = 111,
		NearDistance = 30,
		FarDistance = 60,
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
		ColorRed = 178,
		ColorGreen = 70,
		ColorBlue = 49,
		NearDistance = 50,
		FarDistance = 100,
		Resource = M["Light_Fog2"]
	}
end

M["Light_Chandlier"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 4,
		PositionZ = 47,
		Name = "Light_Chandlier",
		Map = M._MAP,
		Resource = M["Light_Chandlier"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_Chandlier"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Light_Chandlier"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 20,
		Resource = M["Light_Chandlier"]
	}
end

M["Light_Lamp1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47,
		PositionY = 4,
		PositionZ = 49,
		Name = "Light_Lamp1",
		Map = M._MAP,
		Resource = M["Light_Lamp1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_Lamp1"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Light_Lamp1"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 4,
		Resource = M["Light_Lamp1"]
	}
end

M["Light_Lamp2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19,
		PositionY = 4,
		PositionZ = 49,
		Name = "Light_Lamp2",
		Map = M._MAP,
		Resource = M["Light_Lamp2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_Lamp2"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Light_Lamp2"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 4,
		Resource = M["Light_Lamp2"]
	}
end

M["Light_Lamp3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 13,
		PositionY = 4,
		PositionZ = 15,
		Name = "Light_Lamp3",
		Map = M._MAP,
		Resource = M["Light_Lamp3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_Lamp3"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Light_Lamp3"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 4,
		Resource = M["Light_Lamp3"]
	}
end

M["Light_Lamp4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19,
		PositionY = 4,
		PositionZ = 15,
		Name = "Light_Lamp4",
		Map = M._MAP,
		Resource = M["Light_Lamp4"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_Lamp4"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Light_Lamp4"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 4,
		Resource = M["Light_Lamp4"]
	}
end
