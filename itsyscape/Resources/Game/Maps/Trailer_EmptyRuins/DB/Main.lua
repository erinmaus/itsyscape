local M = include "Resources/Game/Maps/Trailer_EmptyRuins/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Trailer_EmptyRuins.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Trailer, Empty Ruins",
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
		PositionX = 23,
		PositionY = 4,
		PositionZ = 7,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Tinkerer1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7,
		PositionY = 6,
		PositionZ = 5,
		Direction = 1,
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
		PositionX = 25,
		PositionY = 9,
		PositionZ = 4,
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

do
	M["Chest"] {
		ItsyScape.Action.Bank()
	}
end
