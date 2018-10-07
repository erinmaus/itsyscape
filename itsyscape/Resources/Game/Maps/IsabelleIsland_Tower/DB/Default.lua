local M = {}

M._MAP = ItsyScape.Resource.Map "IsabelleIsland_Tower"

M["Door_Merchant"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41.000000,
		PositionY = 4.000000,
		PositionZ = 29.000000,
		RotiationX = 0.000000,
		RotiationY = 0.000000,
		RotiationZ = 0.000000,
		RotiationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Door_Merchant",
		Map = M._MAP,
		Resource = M["Door_Merchant"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_RumbridgeStone",
		MapObject = M["Door_Merchant"]
	}
end

M["Door_Tower"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.000000,
		PositionY = 4.000000,
		PositionZ = 43.750000,
		RotiationX = 0.000000,
		RotiationY = 0.000000,
		RotiationZ = 0.000000,
		RotiationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Door_Tower",
		Map = M._MAP,
		Resource = M["Door_Tower"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_RumbridgeStone",
		MapObject = M["Door_Tower"]
	}
end

M["Door_Office"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25.000000,
		PositionY = 4.000000,
		PositionZ = 29.000000,
		RotiationX = 0.000000,
		RotiationY = 0.000000,
		RotiationZ = 0.000000,
		RotiationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Door_Office",
		Map = M._MAP,
		Resource = M["Door_Office"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_RumbridgeStone",
		MapObject = M["Door_Office"]
	}
end

return M
