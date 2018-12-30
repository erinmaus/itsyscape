local M = {}

M._MAP = ItsyScape.Resource.Map "HighChambersYendor_Floor1West"

M["WoodenLadder_Default1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 51.000000,
		PositionY = 2.000000,
		PositionZ = 51.000000,
		RotiationX = 0.000000,
		RotiationY = 0.000000,
		RotiationZ = 0.000000,
		RotiationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "WoodenLadder_Default1",
		Map = M._MAP,
		Resource = M["WoodenLadder_Default1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["WoodenLadder_Default1"]
	}
end

M["WoodenLadder_Default2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 55.000000,
		PositionY = 2.000000,
		PositionZ = 55.000000,
		RotiationX = 0.000000,
		RotiationY = 0.000000,
		RotiationZ = 0.000000,
		RotiationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "WoodenLadder_Default2",
		Map = M._MAP,
		Resource = M["WoodenLadder_Default2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["WoodenLadder_Default2"]
	}
end

return M
