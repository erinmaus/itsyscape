local M = include "Resources/Game/Maps/Skilling_MiningHumanityEdgeAzatite/DB/Default.lua"

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
		ColorGreen = 173,
		ColorBlue = 119,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.3,
		Resource = M["Light_Ambient"]
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
		ColorRed = 51,
		ColorGreen = 157,
		ColorBlue = 128,
		NearDistance = 10,
		FarDistance = 30,
		Resource = M["Light_Fog"]
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
		ColorRed = 130,
		ColorGreen = 130,
		ColorBlue = 130,
		CastsShadows = 1,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 8,
		DirectionZ = -4,
		Resource = M["Light_Sun"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = -3,
		PositionZ = 15,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

 ItsyScape.Meta.Light {
	ColorRed = 51,
	ColorGreen = 157,
	ColorBlue = 128,
	Resource = M["ColorfulFire1"]
}

ItsyScape.Meta.PointLight {
	Attenuation = 2,
	Resource = M["ColorfulFire1"]
}

ItsyScape.Meta.Light {
	ColorRed = 51,
	ColorGreen = 157,
	ColorBlue = 128,
	Resource = M["ColorfulFire2"]
}

ItsyScape.Meta.PointLight {
	Attenuation = 2,
	Resource = M["ColorfulFire2"]
}

ItsyScape.Meta.Light {
	ColorRed = 51,
	ColorGreen = 157,
	ColorBlue = 128,
	Resource = M["ColorfulFire3"]
}

ItsyScape.Meta.PointLight {
	Attenuation = 2,
	Resource = M["ColorfulFire3"]
}

ItsyScape.Meta.Light {
	ColorRed = 51,
	ColorGreen = 157,
	ColorBlue = 128,
	Resource = M["ColorfulFire4"]
}

ItsyScape.Meta.PointLight {
	Attenuation = 2,
	Resource = M["ColorfulFire4"]
}

ItsyScape.Meta.Light {
	ColorRed = 51,
	ColorGreen = 157,
	ColorBlue = 128,
	Resource = M["ColorfulFire5"]
}

ItsyScape.Meta.PointLight {
	Attenuation = 2,
	Resource = M["ColorfulFire5"]
}

ItsyScape.Meta.Light {
	ColorRed = 51,
	ColorGreen = 157,
	ColorBlue = 128,
	Resource = M["ColorfulFire6"]
}

ItsyScape.Meta.PointLight {
	Attenuation = 2,
	Resource = M["ColorfulFire6"]
}
