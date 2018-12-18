local M = include "Resources/Game/Maps/IsabelleIsland_Ocean/DB/Default.lua"

M["UndeadSquid"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 0,
		PositionZ = 21,
		Name = "UndeadSquid",
		Map = M._MAP,
		Resource = M["UndeadSquid"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid",
		MapObject = M["UndeadSquid"]
	}
end
