local M = {}

M._MAP = ItsyScape.Resource.Map "PAXCandleTower"

M["Art_Rage_Fire4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15.000000,
		PositionY = 1.000000,
		PositionZ = 33.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 4.500000,
		ScaleY = 4.500000,
		ScaleZ = 4.500000,
		Name = "Art_Rage_Fire4",
		Map = M._MAP,
		Resource = M["Art_Rage_Fire4"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Art_Rage_Fire",
		MapObject = M["Art_Rage_Fire4"]
	}
end

M["Art_Rage_Fire5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47.000000,
		PositionY = 1.000000,
		PositionZ = 33.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 4.250000,
		ScaleY = 4.250000,
		ScaleZ = 4.250000,
		Name = "Art_Rage_Fire5",
		Map = M._MAP,
		Resource = M["Art_Rage_Fire5"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Art_Rage_Fire",
		MapObject = M["Art_Rage_Fire5"]
	}
end

return M
