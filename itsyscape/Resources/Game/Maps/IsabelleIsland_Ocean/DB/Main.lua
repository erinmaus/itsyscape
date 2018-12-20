local M = include "Resources/Game/Maps/IsabelleIsland_Ocean/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.IsabelleIsland_Ocean.Peep",
	Resource = M._MAP
}

M["UndeadSquid"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 1,
		PositionZ = 19,
		Name = "UndeadSquid",
		Map = M._MAP,
		Resource = M["UndeadSquid"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid",
		MapObject = M["UndeadSquid"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 1,
		PositionZ = 19,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Anchor_Left"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 5,
		PositionY = 1,
		PositionZ = 19,
		Name = "Anchor_Left",
		Map = M._MAP,
		Resource = M["Anchor_Left"]
	}
end

M["Anchor_Right"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 57,
		PositionY = 1,
		PositionZ = 19,
		Name = "Anchor_Right",
		Map = M._MAP,
		Resource = M["Anchor_Right"]
	}
end

M["Anchor_Cannon1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 1,
		PositionZ = 19,
		Name = "Anchor_Cannon1",
		Map = M._MAP,
		Resource = M["Anchor_Cannon1"]
	}
end

M["Anchor_Cannon2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 1,
		PositionZ = 19,
		Name = "Anchor_Cannon2",
		Map = M._MAP,
		Resource = M["Anchor_Cannon2"]
	}
end
