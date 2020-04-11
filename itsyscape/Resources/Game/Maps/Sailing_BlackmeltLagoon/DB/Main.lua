local M = include "Resources/Game/Maps/Sailing_BlackmeltLagoon/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Sailing_BlackmeltLagoon.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Blackmelt Lagoon",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Pre-historic fish swim in these waters on occassion...",
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
		ColorGreen = 33,
		ColorBlue = 66,
		NearDistance = 100,
		FarDistance = 300,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_Ship"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 51,
		PositionY = 2.5,
		PositionZ = 71,
		Name = "Anchor_Ship",
		Map = M._MAP,
		Resource = M["Anchor_Ship"]
	}
end

M["Clucker1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 5,
		PositionZ = 47,
		Direction = -1,
		Name = "Clucker1",
		Map = M._MAP,
		Resource = M["Clucker1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chicken_Island",
		MapObject = M["Clucker1"]
	}
end

M["Clucker2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 51,
		PositionY = 5,
		PositionZ = 35,
		Direction = 1,
		Name = "Clucker2",
		Map = M._MAP,
		Resource = M["Clucker2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chicken_Island",
		MapObject = M["Clucker2"]
	}
end

M["Clucker3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
		PositionY = 5,
		PositionZ = 41,
		Direction = 1,
		Name = "Clucker3",
		Map = M._MAP,
		Resource = M["Clucker3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chicken_Island",
		MapObject = M["Clucker3"]
	}
end

M["Clucker4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 71,
		PositionY = 6,
		PositionZ = 43,
		Direction = 1,
		Name = "Clucker4",
		Map = M._MAP,
		Resource = M["Clucker4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chicken_Island",
		MapObject = M["Clucker4"]
	}
end

M["Clucker5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 95,
		PositionY = 5,
		PositionZ = 61,
		Direction = 1,
		Name = "Clucker5",
		Map = M._MAP,
		Resource = M["Clucker5"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chicken_Island",
		MapObject = M["Clucker5"]
	}
end

M["Clucker6"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 103,
		PositionY = 6,
		PositionZ = 81,
		Direction = 1,
		Name = "Clucker6",
		Map = M._MAP,
		Resource = M["Clucker6"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chicken_Island",
		MapObject = M["Clucker6"]
	}
end

M["Clucker7"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 101,
		PositionY = 7,
		PositionZ = 89,
		Direction = 1,
		Name = "Clucker7",
		Map = M._MAP,
		Resource = M["Clucker7"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chicken_Island",
		MapObject = M["Clucker7"]
	}
end

M["Clucker8"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 79,
		PositionY = 6,
		PositionZ = 118,
		Direction = 1,
		Name = "Clucker8",
		Map = M._MAP,
		Resource = M["Clucker8"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chicken_Island",
		MapObject = M["Clucker8"]
	}
end
