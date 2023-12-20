local M = {}

M._MAP = ItsyScape.Resource.Map "Behemoth_Side"

M["ItsyRock_Default1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 3.000000,
		PositionY = 0.000000,
		PositionZ = 5.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "ItsyRock_Default1",
		Map = M._MAP,
		Resource = M["ItsyRock_Default1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ItsyRock_Default",
		MapObject = M["ItsyRock_Default1"]
	}
end

return M
