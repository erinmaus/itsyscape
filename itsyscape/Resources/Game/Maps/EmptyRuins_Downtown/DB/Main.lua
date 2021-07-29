local M = include "Resources/Game/Maps/EmptyRuins_Downtown/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.EmptyRuins_Downtown.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Downtown, Empty Ruins",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Only the strongest of wills resist the temptation of death in this horrible place.",
	Language = "en-US",
	Resource = M._MAP
}

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
		PositionY = 5,
		PositionZ = 9,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["GoryMass1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 6,
		PositionZ = 13,
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
		PositionX = 51,
		PositionY = 6,
		PositionZ = 57,
		Name = "GoryMass2",
		Map = M._MAP,
		Resource = M["GoryMass2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "GoryMass",
		MapObject = M["GoryMass2"]
	}
end

M["GoryMass3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 6,
		PositionZ = 79,
		Name = "GoryMass3",
		Map = M._MAP,
		Resource = M["GoryMass3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "GoryMass",
		MapObject = M["GoryMass3"]
	}
end

M["Tinkerer1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 4,
		PositionZ = 27,
		Direction = -1,
		Name = "Tinkerer1",
		Map = M._MAP,
		Resource = M["Tinkerer1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Tinkerer",
		MapObject = M["Tinkerer1"]
	}
end

M["Tinkerer2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 77,
		PositionY = 4,
		PositionZ = 31,
		Direction = -1,
		Name = "Tinkerer2",
		Map = M._MAP,
		Resource = M["Tinkerer2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Tinkerer",
		MapObject = M["Tinkerer2"]
	}
end

M["PrestigiousAncientSkeleton1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 9,
		PositionY = 4,
		PositionZ = 35,
		Direction = 1,
		Name = "PrestigiousAncientSkeleton1",
		Map = M._MAP,
		Resource = M["PrestigiousAncientSkeleton1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PrestigiousAncientSkeleton",
		MapObject = M["PrestigiousAncientSkeleton1"]
	}
end

M["PrestigiousAncientSkeleton2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 55,
		PositionY = 4.5,
		PositionZ = 51,
		Name = "PrestigiousAncientSkeleton2",
		Map = M._MAP,
		Resource = M["PrestigiousAncientSkeleton2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PrestigiousAncientSkeleton",
		MapObject = M["PrestigiousAncientSkeleton2"]
	}
end