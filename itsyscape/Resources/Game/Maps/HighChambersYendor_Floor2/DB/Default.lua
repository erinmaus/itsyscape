local M = {}

M._MAP = ItsyScape.Resource.Map "HighChambersYendor_Floor2"

M["Ladder_ToFloor1West"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 101.000000,
		PositionY = 2.000000,
		PositionZ = 99.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Ladder_ToFloor1West",
		Map = M._MAP,
		Resource = M["Ladder_ToFloor1West"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["Ladder_ToFloor1West"]
	}
end

M["Ladder_ToFloor3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 113.000000,
		PositionY = 0.000000,
		PositionZ = 99.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Ladder_ToFloor3",
		Map = M._MAP,
		Resource = M["Ladder_ToFloor3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["Ladder_ToFloor3"]
	}
end

return M
