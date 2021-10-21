local M = {}

M._MAP = ItsyScape.Resource.Map "Rumbridge_Castle_Floor2"

M["Chandelier_Default2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33.000000,
		PositionY = 7.250000,
		PositionZ = 29.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Chandelier_Default2",
		Map = M._MAP,
		Resource = M["Chandelier_Default2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Chandelier_Default",
		MapObject = M["Chandelier_Default2"]
	}
end

M["Throne_Rumbridge2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33.000000,
		PositionY = 1.000000,
		PositionZ = 15.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Throne_Rumbridge2",
		Map = M._MAP,
		Resource = M["Throne_Rumbridge2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Throne_Rumbridge",
		MapObject = M["Throne_Rumbridge2"]
	}
end

M["ArmorStand_Iron1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27.000000,
		PositionY = 0.000000,
		PositionZ = 13.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "ArmorStand_Iron1",
		Map = M._MAP,
		Resource = M["ArmorStand_Iron1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ArmorStand_Iron",
		MapObject = M["ArmorStand_Iron1"]
	}
end

M["Art21"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.000000,
		PositionY = 0.625000,
		PositionZ = 11.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Art21",
		Map = M._MAP,
		Resource = M["Art21"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Art2",
		MapObject = M["Art21"]
	}
end

M["ArmorStand_Iron2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39.000000,
		PositionY = 0.000000,
		PositionZ = 13.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "ArmorStand_Iron2",
		Map = M._MAP,
		Resource = M["ArmorStand_Iron2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ArmorStand_Iron",
		MapObject = M["ArmorStand_Iron2"]
	}
end

M["Art11"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37.000000,
		PositionY = 0.625000,
		PositionZ = 11.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Art11",
		Map = M._MAP,
		Resource = M["Art11"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Art1",
		MapObject = M["Art11"]
	}
end

return M
