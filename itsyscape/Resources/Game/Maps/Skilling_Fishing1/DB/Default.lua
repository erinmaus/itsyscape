local M = {}

M._MAP = ItsyScape.Resource.Map "Skilling_Fishing1"

M["ActionCommand_OceanWater1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 16.000000,
		PositionY = 0.000000,
		PositionZ = 16.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 2.000000,
		ScaleY = 1.250000,
		ScaleZ = 2.000000,
		Name = "ActionCommand_OceanWater1",
		Map = M._MAP,
		Resource = M["ActionCommand_OceanWater1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ActionCommand_OceanWater1",
		MapObject = M["ActionCommand_OceanWater1"]
	}
end

return M
