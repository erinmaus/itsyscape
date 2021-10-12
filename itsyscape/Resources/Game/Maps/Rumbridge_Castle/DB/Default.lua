local M = {}

M._MAP = ItsyScape.Resource.Map "Rumbridge_Castle"

M["Chest_Default1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19.000000,
		PositionY = 4.000000,
		PositionZ = 31.000000,
		RotationX = 0.000000,
		RotationY = 1.000000,
		RotationZ = 0.000000,
		RotationW = 0.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Chest_Default1",
		Map = M._MAP,
		Resource = M["Chest_Default1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Chest_Default",
		MapObject = M["Chest_Default1"]
	}
end

M["Crate_Default112"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23.000000,
		PositionY = 5.375000,
		PositionZ = 27.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default112",
		Map = M._MAP,
		Resource = M["Crate_Default112"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default112"]
	}
end

M["DiningTable_Fancy3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41.000000,
		PositionY = 4.000000,
		PositionZ = 21.000000,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = -0.707107,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "DiningTable_Fancy3",
		Map = M._MAP,
		Resource = M["DiningTable_Fancy3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "DiningTable_Fancy",
		MapObject = M["DiningTable_Fancy3"]
	}
end

M["Crate_Default12"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27.000000,
		PositionY = 4.000000,
		PositionZ = 13.000000,
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

M["ArmorStand_Iron2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43.000000,
		PositionY = 4.000000,
		PositionZ = 34.500000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = -1.000000,
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

M["Crate_Default116"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25.000000,
		PositionY = 4.000000,
		PositionZ = 31.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default116",
		Map = M._MAP,
		Resource = M["Crate_Default116"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default116"]
	}
end

M["Table_2x2_Default2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25.000000,
		PositionY = 4.000000,
		PositionZ = 23.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Table_2x2_Default2",
		Map = M._MAP,
		Resource = M["Table_2x2_Default2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Table_2x2_Default",
		MapObject = M["Table_2x2_Default2"]
	}
end

M["KitchenShelf_Default2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27.250000,
		PositionY = 4.000000,
		PositionZ = 23.375000,
		RotationX = 0.000000,
		RotationY = 1.000000,
		RotationZ = 0.000000,
		RotationW = 0.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "KitchenShelf_Default2",
		Map = M._MAP,
		Resource = M["KitchenShelf_Default2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "KitchenShelf_Default",
		MapObject = M["KitchenShelf_Default2"]
	}
end

M["Crate_Default15"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.000000,
		PositionY = 4.000000,
		PositionZ = 15.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default15",
		Map = M._MAP,
		Resource = M["Crate_Default15"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default15"]
	}
end

M["Crate_Default16"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.000000,
		PositionY = 6.625000,
		PositionZ = 13.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default16",
		Map = M._MAP,
		Resource = M["Crate_Default16"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default16"]
	}
end

M["Crate_Default18"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23.000000,
		PositionY = 4.000000,
		PositionZ = 27.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default18",
		Map = M._MAP,
		Resource = M["Crate_Default18"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default18"]
	}
end

M["CookingRange_Default4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21.000000,
		PositionY = 4.000000,
		PositionZ = 13.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "CookingRange_Default4",
		Map = M._MAP,
		Resource = M["CookingRange_Default4"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "CookingRange_Default",
		MapObject = M["CookingRange_Default4"]
	}
end

M["Crate_Default14"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.000000,
		PositionY = 5.375000,
		PositionZ = 13.000000,
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

M["DiningTableChair_Fancy5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41.000000,
		PositionY = 4.000000,
		PositionZ = 19.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "DiningTableChair_Fancy5",
		Map = M._MAP,
		Resource = M["DiningTableChair_Fancy5"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "DiningTableChair_Fancy",
		MapObject = M["DiningTableChair_Fancy5"]
	}
end

M["SpiralStaircase_Default1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15.000000,
		PositionY = 4.000000,
		PositionZ = 13.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "SpiralStaircase_Default1",
		Map = M._MAP,
		Resource = M["SpiralStaircase_Default1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "SpiralStaircase_Default",
		MapObject = M["SpiralStaircase_Default1"]
	}
end

M["CookingRange_Default1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19.000000,
		PositionY = 4.000000,
		PositionZ = 13.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "CookingRange_Default1",
		Map = M._MAP,
		Resource = M["CookingRange_Default1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "CookingRange_Default",
		MapObject = M["CookingRange_Default1"]
	}
end

M["Fireplace_Default1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41.000000,
		PositionY = 4.000000,
		PositionZ = 11.750000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Fireplace_Default1",
		Map = M._MAP,
		Resource = M["Fireplace_Default1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Fireplace_Default",
		MapObject = M["Fireplace_Default1"]
	}
end

M["DiningTableChair_Fancy6"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 44.000000,
		PositionY = 4.000000,
		PositionZ = 19.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "DiningTableChair_Fancy6",
		Map = M._MAP,
		Resource = M["DiningTableChair_Fancy6"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "DiningTableChair_Fancy",
		MapObject = M["DiningTableChair_Fancy6"]
	}
end

M["Crate_Default114"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.000000,
		PositionY = 5.250000,
		PositionZ = 27.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default114",
		Map = M._MAP,
		Resource = M["Crate_Default114"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default114"]
	}
end

M["SpiralStaircase_Default4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47.000000,
		PositionY = 0.000000,
		PositionZ = 39.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "SpiralStaircase_Default4",
		Map = M._MAP,
		Resource = M["SpiralStaircase_Default4"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "SpiralStaircase_Default",
		MapObject = M["SpiralStaircase_Default4"]
	}
end

M["Chair_Default1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23.000000,
		PositionY = 4.000000,
		PositionZ = 19.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Chair_Default1",
		Map = M._MAP,
		Resource = M["Chair_Default1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Chair_Default",
		MapObject = M["Chair_Default1"]
	}
end

M["DiningTableChair_Fancy4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 38.000000,
		PositionY = 4.000000,
		PositionZ = 19.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "DiningTableChair_Fancy4",
		Map = M._MAP,
		Resource = M["DiningTableChair_Fancy4"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "DiningTableChair_Fancy",
		MapObject = M["DiningTableChair_Fancy4"]
	}
end

M["Art11"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41.000000,
		PositionY = 5.500000,
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

M["Crate_Default115"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.000000,
		PositionY = 6.500000,
		PositionZ = 27.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default115",
		Map = M._MAP,
		Resource = M["Crate_Default115"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default115"]
	}
end

M["Crate_Default121"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21.000000,
		PositionY = 4.000000,
		PositionZ = 31.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default121",
		Map = M._MAP,
		Resource = M["Crate_Default121"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default121"]
	}
end

M["Crate_Default11"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.000000,
		PositionY = 4.000000,
		PositionZ = 13.000000,
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

M["WoodenLadder_Default2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.000000,
		PositionY = 2.000000,
		PositionZ = 29.000000,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = 0.707107,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "WoodenLadder_Default2",
		Map = M._MAP,
		Resource = M["WoodenLadder_Default2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["WoodenLadder_Default2"]
	}
end

M["Chair_Default4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21.000000,
		PositionY = 4.000000,
		PositionZ = 21.000000,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = 0.707107,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Chair_Default4",
		Map = M._MAP,
		Resource = M["Chair_Default4"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Chair_Default",
		MapObject = M["Chair_Default4"]
	}
end

M["Crate_Default117"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27.000000,
		PositionY = 4.000000,
		PositionZ = 21.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default117",
		Map = M._MAP,
		Resource = M["Crate_Default117"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default117"]
	}
end

M["Crate_Default110"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27.000000,
		PositionY = 4.000000,
		PositionZ = 27.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default110",
		Map = M._MAP,
		Resource = M["Crate_Default110"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default110"]
	}
end

M["Crate_Default13"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27.000000,
		PositionY = 5.250000,
		PositionZ = 13.000000,
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

M["Coelacanth_Dead2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25.000000,
		PositionY = 6.125000,
		PositionZ = 22.625000,
		RotationX = 0.000000,
		RotationY = -0.831470,
		RotationZ = 0.000000,
		RotationW = -0.555570,
		ScaleX = 2.000000,
		ScaleY = 1.000000,
		ScaleZ = 2.000000,
		Name = "Coelacanth_Dead2",
		Map = M._MAP,
		Resource = M["Coelacanth_Dead2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Coelacanth_Dead",
		MapObject = M["Coelacanth_Dead2"]
	}
end

M["Chair_Default2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25.000000,
		PositionY = 4.000000,
		PositionZ = 19.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Chair_Default2",
		Map = M._MAP,
		Resource = M["Chair_Default2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Chair_Default",
		MapObject = M["Chair_Default2"]
	}
end

M["KitchenSink_Default4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 24.000000,
		PositionY = 4.000000,
		PositionZ = 13.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "KitchenSink_Default4",
		Map = M._MAP,
		Resource = M["KitchenSink_Default4"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "KitchenSink_Default",
		MapObject = M["KitchenSink_Default4"]
	}
end

M["Crate_Default113"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25.000000,
		PositionY = 5.375000,
		PositionZ = 27.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default113",
		Map = M._MAP,
		Resource = M["Crate_Default113"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default113"]
	}
end

M["Crate_Default120"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23.000000,
		PositionY = 4.000000,
		PositionZ = 31.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default120",
		Map = M._MAP,
		Resource = M["Crate_Default120"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default120"]
	}
end

M["Crate_Default118"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.000000,
		PositionY = 4.000000,
		PositionZ = 31.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default118",
		Map = M._MAP,
		Resource = M["Crate_Default118"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default118"]
	}
end

M["DiningTableChair_Fancy1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 38.000000,
		PositionY = 4.000000,
		PositionZ = 23.000000,
		RotationX = 0.000000,
		RotationY = 1.000000,
		RotationZ = 0.000000,
		RotationW = 0.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "DiningTableChair_Fancy1",
		Map = M._MAP,
		Resource = M["DiningTableChair_Fancy1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "DiningTableChair_Fancy",
		MapObject = M["DiningTableChair_Fancy1"]
	}
end

M["DiningTableChair_Fancy3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 44.000000,
		PositionY = 4.000000,
		PositionZ = 23.000000,
		RotationX = 0.000000,
		RotationY = 1.000000,
		RotationZ = 0.000000,
		RotationW = 0.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "DiningTableChair_Fancy3",
		Map = M._MAP,
		Resource = M["DiningTableChair_Fancy3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "DiningTableChair_Fancy",
		MapObject = M["DiningTableChair_Fancy3"]
	}
end

M["Crate_Default111"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.000000,
		PositionY = 4.000000,
		PositionZ = 27.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default111",
		Map = M._MAP,
		Resource = M["Crate_Default111"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default111"]
	}
end

M["Art33"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27.000000,
		PositionY = 5.375000,
		PositionZ = 33.500000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Art33",
		Map = M._MAP,
		Resource = M["Art33"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Art3",
		MapObject = M["Art33"]
	}
end

M["Chair_Default3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21.000000,
		PositionY = 4.000000,
		PositionZ = 23.000000,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = 0.707107,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Chair_Default3",
		Map = M._MAP,
		Resource = M["Chair_Default3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Chair_Default",
		MapObject = M["Chair_Default3"]
	}
end

M["Crate_Default17"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21.000000,
		PositionY = 4.000000,
		PositionZ = 27.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default17",
		Map = M._MAP,
		Resource = M["Crate_Default17"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default17"]
	}
end

M["Crate_Default19"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25.000000,
		PositionY = 4.000000,
		PositionZ = 27.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default19",
		Map = M._MAP,
		Resource = M["Crate_Default19"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default19"]
	}
end

M["ArmorStand_Iron1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37.000000,
		PositionY = 4.000000,
		PositionZ = 34.500000,
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

M["DiningTableChair_Fancy2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41.000000,
		PositionY = 4.000000,
		PositionZ = 23.000000,
		RotationX = 0.000000,
		RotationY = 1.000000,
		RotationZ = 0.000000,
		RotationW = 0.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "DiningTableChair_Fancy2",
		Map = M._MAP,
		Resource = M["DiningTableChair_Fancy2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "DiningTableChair_Fancy",
		MapObject = M["DiningTableChair_Fancy2"]
	}
end

M["Crate_Default119"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27.000000,
		PositionY = 4.000000,
		PositionZ = 31.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Crate_Default119",
		Map = M._MAP,
		Resource = M["Crate_Default119"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_Default119"]
	}
end

return M
