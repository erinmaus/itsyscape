local M = {}

M._MAP = ItsyScape.Resource.Map "Test_Water"

M["ComfyChair_Isabelle1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33.000000,
		PositionY = 3.000000,
		PositionZ = 39.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "ComfyChair_Isabelle1",
		Map = M._MAP,
		Resource = M["ComfyChair_Isabelle1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ComfyChair_Isabelle",
		MapObject = M["ComfyChair_Isabelle1"]
	}
end

M["ComfyChair_Isabelle2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41.000000,
		PositionY = 0.000000,
		PositionZ = 39.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "ComfyChair_Isabelle2",
		Map = M._MAP,
		Resource = M["ComfyChair_Isabelle2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ComfyChair_Isabelle",
		MapObject = M["ComfyChair_Isabelle2"]
	}
end

M["ComfyChair_Isabelle3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21.000000,
		PositionY = 3.250000,
		PositionZ = 33.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = -0.382683,
		RotationW = 0.923880,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "ComfyChair_Isabelle3",
		Map = M._MAP,
		Resource = M["ComfyChair_Isabelle3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ComfyChair_Isabelle",
		MapObject = M["ComfyChair_Isabelle3"]
	}
end

return M
