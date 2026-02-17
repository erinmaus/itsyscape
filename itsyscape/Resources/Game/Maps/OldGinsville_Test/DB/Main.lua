local M = include "Resources/Game/Maps/OldGinsville_Test/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.OldGinsville_Test.Peep",
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
		ColorRed = 113,
		ColorGreen = 55,
		ColorBlue = 200,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.5,
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
		ColorRed = 67,
		ColorGreen = 59,
		ColorBlue = 90,
		NearDistance = 30,
		FarDistance = 45,
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
		ColorRed = 100,
		ColorGreen = 100,
		ColorBlue = 100,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 3,
		DirectionZ = 4,
		Resource = M["Light_Sun"]
	}
end

M["Light_Directional"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Directional",
		Map = M._MAP,
		Resource = M["Light_Directional"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "DirectionalLight_Default",
		MapObject = M["Light_Directional"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 67,
		ColorGreen = 59,
		ColorBlue = 90,
		Resource = M["Light_Directional"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 0,
		DirectionY = 2,
		DirectionZ = -1,
		Resource = M["Light_Directional"]
	}
end

M["MedicalTinkerer"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 79,
		PositionY = 0,
		PositionZ = 91,
		Name = "MedicalTinkerer",
		Map = M._MAP,
		Resource = M["MedicalTinkerer"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "MedicalTinkerer",
		MapObject = M["MedicalTinkerer"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 79,
		PositionY = 0,
		PositionZ = 91,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end
