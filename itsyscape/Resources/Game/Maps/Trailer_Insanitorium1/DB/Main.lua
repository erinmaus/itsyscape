local M = include "Resources/Game/Maps/Trailer_Insanitorium1/DB/Default.lua"

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
		Ambience = 0.7,
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
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
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
		ColorBlue = 200,
		NearDistance = 40,
		FarDistance = 60,
		FollowTarget = 1,
		Resource = M["Light_Fog"]
	}
end

M["GoryMass1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7,
		PositionY = 2,
		PositionZ = 19,
		Name = "GoryMass1",
		Map = M._MAP,
		Resource = M["GoryMass1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "GoryMass",
		MapObject = M["GoryMass1"]
	}
end

M["GoryMass2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41,
		PositionY = 2,
		PositionZ = 17,
		Name = "GoryMass2",
		Map = M._MAP,
		Resource = M["GoryMass2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "GoryMass",
		MapObject = M["GoryMass2"]
	}
end

M["Prisoner1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 9,
		PositionY = 0,
		PositionZ = 9,
		Name = "Prisoner1",
		Map = M._MAP,
		Resource = M["Prisoner1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Svalbard_PartiallyDigestedAdventurer",
		MapObject = M["Prisoner1"]
	}
end

M["Prisoner2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21,
		PositionY = 0,
		PositionZ = 5,
		Direction = -1,
		Name = "Prisoner2",
		Map = M._MAP,
		Resource = M["Prisoner2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CinematicTrailer1_Warrior",
		MapObject = M["Prisoner2"]
	}
end

M["Prisoner3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 0,
		PositionZ = 11,
		Direction = 1,
		Name = "Prisoner3",
		Map = M._MAP,
		Resource = M["Prisoner3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CinematicTrailer1_Wizard",
		MapObject = M["Prisoner3"]
	}
end

M["Prisoner4X"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21,
		PositionY = 0,
		PositionZ = 11,
		Direction = -1,
		Name = "Prisoner4X",
		Map = M._MAP,
		Resource = M["Prisoner4X"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CinematicTrailer1_Archer",
		MapObject = M["Prisoner4X"]
	}
end

M["Prisoner5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 0,
		PositionZ = 11,
		Name = "Prisoner5",
		Map = M._MAP,
		Resource = M["Prisoner5"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Mummy",
		MapObject = M["Prisoner5"]
	}
end

M["Boop1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 17,
		PositionY = 0,
		PositionZ = 17,
		Name = "Boop1",
		Map = M._MAP,
		Resource = M["Boop1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Boop",
		MapObject = M["Boop1"]
	}
end

M["Boop2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 0,
		PositionZ = 23,
		Name = "Boop2",
		Map = M._MAP,
		Resource = M["Boop2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Boop",
		MapObject = M["Boop2"]
	}
end

M["Boop3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19,
		PositionY = 0,
		PositionZ = 21,
		Name = "Boop3",
		Map = M._MAP,
		Resource = M["Boop3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Boop",
		MapObject = M["Boop3"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 0,
		PositionZ = 21,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

do
	M["Door_IronGate4"] {
		ItsyScape.Action.Open()
	}

	M["Door_IronGate5"] {
		ItsyScape.Action.Open()
	}

	M["Door_IronGate6"] {
		ItsyScape.Action.Open()
	}
end
