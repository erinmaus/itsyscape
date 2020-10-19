local M = include "Resources/Game/Maps/Rumbridge_HexLabs_Floor1/DB/Default.lua"

ItsyScape.Meta.ResourceName {
	Value = "Hex Labs, Inc., Floor 1",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "A terrifying lab for the insane Techromancer, Hex.",
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
		ColorRed = 124,
		ColorGreen = 111,
		ColorBlue = 255,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.8,
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
		ColorRed = 90,
		ColorGreen = 90,
		ColorBlue = 255,
		NearDistance = 60,
		FarDistance = 80,
		Resource = M["Light_Fog1"]
	}
end

M["Anchor_FromLeafyLake"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 2,
		PositionZ = 47,
		Name = "Anchor_FromLeafyLake",
		Map = M._MAP,
		Resource = M["Anchor_FromLeafyLake"]
	}
end

M["Drakkenson1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 38,
		PositionY = 3,
		PositionZ = 18,
		Name = "Drakkenson1",
		Map = M._MAP,
		Resource = M["Drakkenson1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Draconic_Sleeping",
		MapObject = M["Drakkenson1"]
	}
end

M["Drakkenson2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 38,
		PositionY = 3,
		PositionZ = 22,
		Name = "Drakkenson2",
		Map = M._MAP,
		Resource = M["Drakkenson2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Draconic_Sleeping",
		MapObject = M["Drakkenson2"]
	}
end

M["Drakkenson3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 38,
		PositionY = 3,
		PositionZ = 26,
		Name = "Drakkenson3",
		Map = M._MAP,
		Resource = M["Drakkenson3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Draconic_Sleeping",
		MapObject = M["Drakkenson3"]
	}
end

M["Drakkenson4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 38,
		PositionY = 3,
		PositionZ = 30,
		Name = "Drakkenson4",
		Map = M._MAP,
		Resource = M["Drakkenson4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Draconic_Sleeping",
		MapObject = M["Drakkenson4"]
	}
end

M["Drakkenson5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 24,
		PositionY = 3,
		PositionZ = 18,
		Name = "Drakkenson5",
		Map = M._MAP,
		Resource = M["Drakkenson5"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Draconic_Sleeping",
		MapObject = M["Drakkenson5"]
	}
end

M["Drakkenson6"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 24,
		PositionY = 3,
		PositionZ = 22,
		Name = "Drakkenson6",
		Map = M._MAP,
		Resource = M["Drakkenson6"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Draconic_Sleeping",
		MapObject = M["Drakkenson6"]
	}
end

M["Drakkenson7"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 24,
		PositionY = 3,
		PositionZ = 26,
		Name = "Drakkenson7",
		Map = M._MAP,
		Resource = M["Drakkenson7"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Draconic_Sleeping",
		MapObject = M["Drakkenson7"]
	}
end

M["Drakkenson8"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 24,
		PositionY = 3,
		PositionZ = 30,
		Name = "Drakkenson8",
		Map = M._MAP,
		Resource = M["Drakkenson8"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Draconic_Sleeping",
		MapObject = M["Drakkenson8"]
	}
end
