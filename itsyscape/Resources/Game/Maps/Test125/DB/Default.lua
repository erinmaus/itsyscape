local M = {}

M._MAP = ItsyScape.Resource.Map "Test125"

M["Desk_Isabelle_DragonBone1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 81.000000,
		PositionY = 1.000000,
		PositionZ = 73.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Desk_Isabelle_DragonBone1",
		Map = M._MAP,
		Resource = M["Desk_Isabelle_DragonBone1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Bed_FourPoster_Isabelle",
		MapObject = M["Desk_Isabelle_DragonBone1"]
	}
end

return M
