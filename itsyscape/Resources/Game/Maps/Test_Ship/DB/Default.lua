local M = {}

M._MAP = ItsyScape.Resource.Map "Test_Ship"

M["Lamp_IsabelleTower1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37.000000,
		PositionY = 3.750000,
		PositionZ = 15.500000,
		RotationX = 0.000000,
		RotationY = -1.000000,
		RotationZ = 0.000000,
		RotationW = 0.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Lamp_IsabelleTower1",
		Map = M._MAP,
		Resource = M["Lamp_IsabelleTower1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Lamp_IsabelleTower",
		MapObject = M["Lamp_IsabelleTower1"]
	}
end

M["Lamp_IsabelleTower2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37.000000,
		PositionY = 3.750000,
		PositionZ = 0.500000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Lamp_IsabelleTower2",
		Map = M._MAP,
		Resource = M["Lamp_IsabelleTower2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Lamp_IsabelleTower",
		MapObject = M["Lamp_IsabelleTower2"]
	}
end

M["Lamp_IsabelleTower3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31.250000,
		PositionY = 3.000000,
		PositionZ = 8.000000,
		RotationX = 0.000000,
		RotationY = -0.707107,
		RotationZ = 0.000000,
		RotationW = -0.707107,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Lamp_IsabelleTower3",
		Map = M._MAP,
		Resource = M["Lamp_IsabelleTower3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Lamp_IsabelleTower",
		MapObject = M["Lamp_IsabelleTower3"]
	}
end

M["Lamp_IsabelleTower4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 11.250000,
		PositionY = 3.000000,
		PositionZ = 8.250000,
		RotationX = 0.000000,
		RotationY = -0.707107,
		RotationZ = 0.000000,
		RotationW = -0.707107,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Lamp_IsabelleTower4",
		Map = M._MAP,
		Resource = M["Lamp_IsabelleTower4"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Lamp_IsabelleTower",
		MapObject = M["Lamp_IsabelleTower4"]
	}
end

M["Lamp_IsabelleTower5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 11.250000,
		PositionY = 3.000000,
		PositionZ = 8.000000,
		RotationX = 0.000000,
		RotationY = -0.707107,
		RotationZ = 0.000000,
		RotationW = -0.707107,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Lamp_IsabelleTower5",
		Map = M._MAP,
		Layer = 2,
		Resource = M["Lamp_IsabelleTower5"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Lamp_IsabelleTower",
		MapObject = M["Lamp_IsabelleTower5"]
	}
end

return M
