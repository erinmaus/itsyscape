local M = {}

M._MAP = ItsyScape.Resource.Map "ViziersRock_MysteriousGraveyard"

M["YewTree_Default11"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39.000000,
		PositionY = 0.000000,
		PositionZ = 29.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "YewTree_Default11",
		Map = M._MAP,
		Resource = M["YewTree_Default11"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "YewTree_Default1",
		MapObject = M["YewTree_Default11"]
	}
end

M["YewTree_Default12"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19.000000,
		PositionY = 0.000000,
		PositionZ = 19.000000,
		RotationX = 0.000000,
		RotationY = -0.414401,
		RotationZ = 0.000000,
		RotationW = -0.910095,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "YewTree_Default12",
		Map = M._MAP,
		Resource = M["YewTree_Default12"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "YewTree_Default1",
		MapObject = M["YewTree_Default12"]
	}
end

M["YewTree_Default13"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15.000000,
		PositionY = 0.000000,
		PositionZ = 51.000000,
		RotationX = 0.000000,
		RotationY = -0.643010,
		RotationZ = 0.000000,
		RotationW = 0.765857,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "YewTree_Default13",
		Map = M._MAP,
		Resource = M["YewTree_Default13"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "YewTree_Default1",
		MapObject = M["YewTree_Default13"]
	}
end

return M
