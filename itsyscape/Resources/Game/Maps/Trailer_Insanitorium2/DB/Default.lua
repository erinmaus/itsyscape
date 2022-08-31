local M = {}

M._MAP = ItsyScape.Resource.Map "Trailer_Insanitorium2"

M["Bones_Skull1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.000000,
		PositionY = 2.000000,
		PositionZ = 5.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Bones_Skull1",
		Map = M._MAP,
		Resource = M["Bones_Skull1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Bones_Skull",
		MapObject = M["Bones_Skull1"]
	}
end

M["Bones_JustBones1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27.000000,
		PositionY = 2.000000,
		PositionZ = 3.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Bones_JustBones1",
		Map = M._MAP,
		Resource = M["Bones_JustBones1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Bones_JustBones",
		MapObject = M["Bones_JustBones1"]
	}
end

M["Bones_PileOfSkulls1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.000000,
		PositionY = 2.000000,
		PositionZ = 3.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Bones_PileOfSkulls1",
		Map = M._MAP,
		Resource = M["Bones_PileOfSkulls1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Bones_PileOfSkulls",
		MapObject = M["Bones_PileOfSkulls1"]
	}
end

return M
