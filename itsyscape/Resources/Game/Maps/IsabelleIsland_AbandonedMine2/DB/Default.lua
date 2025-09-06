local M = {}

M._MAP = ItsyScape.Resource.Map "IsabelleIsland_AbandonedMine2"

M["Brazier_Isabelle1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 51.000000,
		PositionY = 13.000000,
		PositionZ = 61.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Brazier_Isabelle1",
		Map = M._MAP,
		Resource = M["Brazier_Isabelle1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Brazier_Isabelle",
		MapObject = M["Brazier_Isabelle1"]
	}
end

M["Crate_Default11"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 145.000000,
		PositionY = 0.000000,
		PositionZ = 137.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default11",
		Map = M._MAP,
		Resource = M["Crate_Default11"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default11"]
	}
end

M["Crate_Default12"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 147.000000,
		PositionY = 0.000000,
		PositionZ = 137.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default12",
		Map = M._MAP,
		Resource = M["Crate_Default12"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default12"]
	}
end

M["Crate_Default13"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 145.000000,
		PositionY = 0.000000,
		PositionZ = 139.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default13",
		Map = M._MAP,
		Resource = M["Crate_Default13"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default13"]
	}
end

M["Crate_Default14"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 143.000000,
		PositionY = 0.000000,
		PositionZ = 137.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default14",
		Map = M._MAP,
		Resource = M["Crate_Default14"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default14"]
	}
end

M["ShellFossil1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 59.000000,
		PositionY = 13.000000,
		PositionZ = 57.000000,
		RotationX = 0.000000,
		RotationY = 0.382683,
		RotationZ = 0.000000,
		RotationW = -0.923880,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "ShellFossil1",
		Map = M._MAP,
		Resource = M["ShellFossil1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ShellFossil",
		MapObject = M["ShellFossil1"]
	}
end

M["ShellFossil2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 44.023282,
		PositionY = 13.000000,
		PositionZ = 68.308027,
		RotationX = 0.000000,
		RotationY = 0.382683,
		RotationZ = 0.000000,
		RotationW = 0.923880,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "ShellFossil2",
		Map = M._MAP,
		Resource = M["ShellFossil2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ShellFossil",
		MapObject = M["ShellFossil2"]
	}
end

return M
