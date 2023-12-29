local M = include "Resources/Game/Maps/EmptyRuins_DragonValley_Ginsville/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.EmptyRuins_DragonValley_Ginsville.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Ginsville Ruins",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Recently ravaged by the enraged, undead dragon Svalbard.",
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
		ColorRed = 55,
		ColorGreen = 55,
		ColorBlue = 55,
		NearDistance = 10,
		FarDistance = 25,
		FollowTarget = 1,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 30,
		PositionY = 4,
		PositionZ = 91,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Tinkerer"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 4,
		PositionZ = 47,
		Name = "Tinkerer",
		Map = M._MAP,
		Resource = M["Tinkerer"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Tinkerer_DragonValley_Unattackable",
		MapObject = M["Tinkerer"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_Tinkerer",
		Map = M._MAP,
		MapObject = M["Tinkerer"]
	}
end

M["Fire1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 4,
		PositionZ = 69,
		ScaleX = 2.5,
		ScaleY = 4,
		ScaleZ = 2.5,
		Name = "Fire1",
		Map = M._MAP,
		Resource = M["Fire1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "RagingFire",
		MapObject = M["Fire1"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Fire1"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 2,
		DirectionY = 4,
		DirectionZ = 2,
		Resource = M["Fire1"]
	}
end

M["Fire2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 55,
		PositionY = 4,
		PositionZ = 45,
		ScaleX = 3,
		ScaleY = 4,
		ScaleZ = 3,
		Name = "Fire2",
		Map = M._MAP,
		Resource = M["Fire2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "RagingFire",
		MapObject = M["Fire2"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Fire2"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 2,
		DirectionY = 4,
		DirectionZ = 2,
		Resource = M["Fire2"]
	}
end

M["Fire3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 49,
		PositionY = 4,
		PositionZ = 29,
		ScaleX = 1.5,
		ScaleY = 4,
		ScaleZ = 1.5,
		Name = "Fire3",
		Map = M._MAP,
		Resource = M["Fire3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "RagingFire",
		MapObject = M["Fire3"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Fire3"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 2,
		DirectionY = 4,
		DirectionZ = 2,
		Resource = M["Fire3"]
	}
end

M["Fire4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7,
		PositionY = 4,
		PositionZ = 87,
		ScaleX = 3,5,
		ScaleY = 5,
		ScaleZ = 3.5,
		Name = "Fire4",
		Map = M._MAP,
		Resource = M["Fire4"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "RagingFire",
		MapObject = M["Fire4"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Fire4"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 2,
		DirectionY = 4,
		DirectionZ = 2,
		Resource = M["Fire4"]
	}
end

M["ExperimentX"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 4,
		PositionZ = 55,
		Name = "ExperimentX",
		Map = M._MAP,
		Resource = M["ExperimentX"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "ExperimentX",
		MapObject = M["ExperimentX"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}
end

M["Door_Tinkerer1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 28,
		PositionY = 4,
		PositionZ = 43.5,
		Name = "Door_Tinkerer1",
		Map = M._MAP,
		Resource = M["Door_Tinkerer1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_EmptyRuins_Locked",
		MapObject = M["Door_Tinkerer1"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_Tinkerer",
		Map = M._MAP,
		MapObject = M["Door_Tinkerer1"]
	}

	M["Door_Tinkerer1"] {
		ItsyScape.Action.Open(),
		ItsyScape.Action.Close()
	}
end

M["Door_Tinkerer2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19.5,
		PositionY = 4,
		PositionZ = 58,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = 0.707107,
		Name = "Door_Tinkerer2",
		Map = M._MAP,
		Resource = M["Door_Tinkerer2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_EmptyRuins_Locked",
		MapObject = M["Door_Tinkerer2"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_Tinkerer",
		Map = M._MAP,
		MapObject = M["Door_Tinkerer2"]
	}

	M["Door_Tinkerer2"] {
		ItsyScape.Action.Open(),
		ItsyScape.Action.Close()
	}
end

M["Door_Tinkerer3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 44.5,
		PositionY = 4,
		PositionZ = 57,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = -0.707107,
		Name = "Door_Tinkerer3",
		Map = M._MAP,
		Resource = M["Door_Tinkerer3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_EmptyRuins_Single_Locked",
		MapObject = M["Door_Tinkerer3"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_Tinkerer",
		Map = M._MAP,
		MapObject = M["Door_Tinkerer3"]
	}

	M["Door_Tinkerer3"] {
		ItsyScape.Action.Open(),
		ItsyScape.Action.Close()
	}
end

M["Adventurer1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 4,
		PositionZ = 83,
		Name = "Adventurer1",
		Map = M._MAP,
		Resource = M["Adventurer1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "DisemboweledAdventurer",
		MapObject = M["Adventurer1"]
	}
end

M["Adventurer2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 4,
		PositionZ = 77,
		Name = "Adventurer2",
		Map = M._MAP,
		Resource = M["Adventurer2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "DisemboweledAdventurer",
		MapObject = M["Adventurer2"]
	}
end

M["Adventurer3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 4,
		PositionZ = 87,
		Name = "Adventurer3",
		Map = M._MAP,
		Resource = M["Adventurer3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "DisemboweledAdventurer",
		MapObject = M["Adventurer3"]
	}
end

M["Adventurer4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 4,
		PositionZ = 69,
		Name = "Adventurer4",
		Map = M._MAP,
		Resource = M["Adventurer4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "DisemboweledAdventurer",
		MapObject = M["Adventurer4"]
	}
end

M["Adventurer5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 57,
		PositionY = 4,
		PositionZ = 71,
		Name = "Adventurer5",
		Map = M._MAP,
		Resource = M["Adventurer5"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "DisemboweledAdventurer",
		MapObject = M["Adventurer5"]
	}
end
