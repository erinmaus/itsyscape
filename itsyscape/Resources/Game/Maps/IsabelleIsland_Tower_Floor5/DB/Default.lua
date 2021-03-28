local M = {}

M._MAP = ItsyScape.Resource.Map "IsabelleIsland_Tower_Floor5"

M["WoodenLadder_Default3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15.000000,
		PositionY = -2.000000,
		PositionZ = 35.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "WoodenLadder_Default3",
		Map = M._MAP,
		Resource = M["WoodenLadder_Default3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["WoodenLadder_Default3"]
	}
end

return M
