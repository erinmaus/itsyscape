local M = {}

M._MAP = ItsyScape.Resource.Map "Behemoth_Neck"

M["ItsyRock_Default1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 3.000000,
		PositionY = 0.000000,
		PositionZ = 3.000000,
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

M["ItsyRock_Default2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 3.000000,
		PositionY = 0.000000,
		PositionZ = 7.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "ItsyRock_Default2",
		Map = M._MAP,
		Resource = M["ItsyRock_Default2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ItsyRock_Default",
		MapObject = M["ItsyRock_Default2"]
	}
end

return M
