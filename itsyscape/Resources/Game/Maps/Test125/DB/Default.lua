local M = {}

M._MAP = ItsyScape.Resource.Map "Test125"

M["Desk_Isabelle_DragonBone2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 80.500000,
		PositionY = 1.000000,
		PositionZ = 71.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Desk_Isabelle_DragonBone2",
		Map = M._MAP,
		Resource = M["Desk_Isabelle_DragonBone2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Desk_Isabelle_DragonBone",
		MapObject = M["Desk_Isabelle_DragonBone2"]
	}
end

M["Lamp_IsabelleTower1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 81.500000,
		PositionY = 3.000000,
		PositionZ = 70.250000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
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

M["Desk_Isabelle_DragonBone1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 79.000000,
		PositionY = 1.000000,
		PositionZ = 73.000000,
		RotationX = 0.000000,
		RotationY = 0.923880,
		RotationZ = 0.000000,
		RotationW = 0.382683,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Desk_Isabelle_DragonBone1",
		Map = M._MAP,
		Resource = M["Desk_Isabelle_DragonBone1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ComfyChair_Isabelle",
		MapObject = M["Desk_Isabelle_DragonBone1"]
	}
end

M["Chest_Isabelle1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 77.000000,
		PositionY = 1.125000,
		PositionZ = 77.000000,
		RotationX = 0.000000,
		RotationY = 0.955630,
		RotationZ = 0.000000,
		RotationW = 0.294569,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Chest_Isabelle1",
		Map = M._MAP,
		Resource = M["Chest_Isabelle1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Chest_Isabelle",
		MapObject = M["Chest_Isabelle1"]
	}
end

M["WhaleSkeletonStatue1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 81.000000,
		PositionY = 1.000000,
		PositionZ = 55.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "WhaleSkeletonStatue1",
		Map = M._MAP,
		Resource = M["WhaleSkeletonStatue1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WhaleSkeletonStatue",
		MapObject = M["WhaleSkeletonStatue1"]
	}
end

M["Bed_FourPoster_Isabelle1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 85.000000,
		PositionY = 1.000000,
		PositionZ = 72.750000,
		RotationX = 0.000000,
		RotationY = -0.707107,
		RotationZ = 0.000000,
		RotationW = 0.707107,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Bed_FourPoster_Isabelle1",
		Map = M._MAP,
		Resource = M["Bed_FourPoster_Isabelle1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Bed_FourPoster_Isabelle",
		MapObject = M["Bed_FourPoster_Isabelle1"]
	}
end

M["Armoire_Isabelle1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 77.000000,
		PositionY = 1.000000,
		PositionZ = 71.000000,
		RotationX = 0.000000,
		RotationY = 0.382683,
		RotationZ = 0.000000,
		RotationW = 0.923880,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Armoire_Isabelle1",
		Map = M._MAP,
		Resource = M["Armoire_Isabelle1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Armoire_Isabelle",
		MapObject = M["Armoire_Isabelle1"]
	}
end

return M
