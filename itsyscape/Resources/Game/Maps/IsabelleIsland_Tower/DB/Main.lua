local M = include "Resources/Game/Maps/IsabelleIsland_Tower/DB/Default.lua"

M["Anchor_FromPort"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 16.5 * 2,
		PositionY = 1,
		PositionZ = 2.5 * 2,
		Name = "Anchor_FromPort",
		Map = M._MAP,
		Resource = M["Anchor_FromPort"]
	}
end

M["Anchor_StartGame"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 12.5 * 2,
		PositionY = 4,
		PositionZ = 11.5 * 2,
		Name = "Anchor_StartGame",
		Map = M._MAP,
		Resource = M["Anchor_StartGame"]
	}
end

M["Door_Office"] {
	ItsyScape.Action.Open() {
	},

	ItsyScape.Action.Close() {
	}
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 2,
	SizeY = 2,
	SizeZ = 2,
	MapObject = M["Door_Office"]
}

M["Door_Tower"] {
	ItsyScape.Action.Open() {
	},

	ItsyScape.Action.Close() {
	}
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 2,
	SizeY = 2,
	SizeZ = 2,
	MapObject = M["Door_Tower"]
}

M["Door_Merchant"] {
	ItsyScape.Action.Open() {
	},

	ItsyScape.Action.Close() {
	}
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 2,
	SizeY = 2,
	SizeZ = 2,
	MapObject = M["Door_Tower"]
}

return M
