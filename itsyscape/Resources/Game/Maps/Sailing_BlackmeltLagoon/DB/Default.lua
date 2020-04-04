local M = {}

M._MAP = ItsyScape.Resource.Map "Sailing_BlackmeltLagoon"

M["CommonFire2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43.000000,
		PositionY = 6.000000,
		PositionZ = 37.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "CommonFire2",
		Map = M._MAP,
		Resource = M["CommonFire2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "CommonFire",
		MapObject = M["CommonFire2"]
	}
end

M["ShadowTree_Default2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 81.000000,
		PositionY = 6.500000,
		PositionZ = 41.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "ShadowTree_Default2",
		Map = M._MAP,
		Resource = M["ShadowTree_Default2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ShadowTree_Default",
		MapObject = M["ShadowTree_Default2"]
	}
end

M["ShadowTree_Default3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 91.000000,
		PositionY = 5.500000,
		PositionZ = 47.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "ShadowTree_Default3",
		Map = M._MAP,
		Resource = M["ShadowTree_Default3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ShadowTree_Default",
		MapObject = M["ShadowTree_Default3"]
	}
end

M["ShadowTree_Default1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 83.000000,
		PositionY = 8.000000,
		PositionZ = 45.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "ShadowTree_Default1",
		Map = M._MAP,
		Resource = M["ShadowTree_Default1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ShadowTree_Default",
		MapObject = M["ShadowTree_Default1"]
	}
end

M["ShadowTree_Default4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 87.000000,
		PositionY = 6.000000,
		PositionZ = 39.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "ShadowTree_Default4",
		Map = M._MAP,
		Resource = M["ShadowTree_Default4"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ShadowTree_Default",
		MapObject = M["ShadowTree_Default4"]
	}
end

M["ShadowFire1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 91.000000,
		PositionY = 7.000000,
		PositionZ = 43.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "ShadowFire1",
		Map = M._MAP,
		Resource = M["ShadowFire1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ShadowFire",
		MapObject = M["ShadowFire1"]
	}
end

M["ShadowTree_Default5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 87.000000,
		PositionY = 6.000000,
		PositionZ = 49.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "ShadowTree_Default5",
		Map = M._MAP,
		Resource = M["ShadowTree_Default5"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ShadowTree_Default",
		MapObject = M["ShadowTree_Default5"]
	}
end

return M
