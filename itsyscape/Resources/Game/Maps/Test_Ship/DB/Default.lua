local M = {}

M._MAP = ItsyScape.Resource.Map "Test_Ship"

M["Sailing_Hull_NPC_Isabelle_Exquisitor1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.500000,
		PositionY = 0.000000,
		PositionZ = 8.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Sailing_Hull_NPC_Isabelle_Exquisitor1",
		Map = M._MAP,
		Resource = M["Sailing_Hull_NPC_Isabelle_Exquisitor1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Sailing_Hull_NPC_Isabelle_Exquisitor",
		MapObject = M["Sailing_Hull_NPC_Isabelle_Exquisitor1"]
	}
end

return M
