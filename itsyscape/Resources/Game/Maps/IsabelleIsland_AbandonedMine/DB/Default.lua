local M = {}

M._MAP = ItsyScape.Resource.Map "IsabelleIsland_AbandonedMine"

M["CopperRock_Default1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25.000000,
		PositionY = 3.000000,
		PositionZ = 47.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "CopperRock_Default1",
		Map = M._MAP,
		Resource = M["CopperRock_Default1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "CopperRock_Default",
		MapObject = M["CopperRock_Default1"]
	}
end

M["CraftingRoomDoor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 60.000000,
		PositionY = 2.000000,
		PositionZ = 43.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "CraftingRoomDoor",
		Map = M._MAP,
		Resource = M["CraftingRoomDoor"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_RumbridgeDungeon",
		MapObject = M["CraftingRoomDoor"]
	}
end

M["IsabelleIsland_AbandonedMine_Pillar2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 51.000000,
		PositionY = 0.000000,
		PositionZ = 63.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "IsabelleIsland_AbandonedMine_Pillar2",
		Map = M._MAP,
		Resource = M["IsabelleIsland_AbandonedMine_Pillar2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "IsabelleIsland_AbandonedMine_Pillar",
		MapObject = M["IsabelleIsland_AbandonedMine_Pillar2"]
	}
end

M["Torch_Default7"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 65.000000,
		PositionY = 0.000000,
		PositionZ = 55.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Torch_Default7",
		Map = M._MAP,
		Resource = M["Torch_Default7"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Torch_Default",
		MapObject = M["Torch_Default7"]
	}
end

M["Anvil_Default4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 65.000000,
		PositionY = 2.000000,
		PositionZ = 31.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Anvil_Default4",
		Map = M._MAP,
		Resource = M["Anvil_Default4"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Anvil_Default",
		MapObject = M["Anvil_Default4"]
	}
end

M["Torch_Default4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43.000000,
		PositionY = 2.000000,
		PositionZ = 39.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Torch_Default4",
		Map = M._MAP,
		Resource = M["Torch_Default4"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Torch_Default",
		MapObject = M["Torch_Default4"]
	}
end

M["CopperRock_Default2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31.000000,
		PositionY = 2.000000,
		PositionZ = 33.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "CopperRock_Default2",
		Map = M._MAP,
		Resource = M["CopperRock_Default2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "CopperRock_Default",
		MapObject = M["CopperRock_Default2"]
	}
end

M["TinRock_Default6"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 83.000000,
		PositionY = 1.000000,
		PositionZ = 37.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "TinRock_Default6",
		Map = M._MAP,
		Resource = M["TinRock_Default6"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "TinRock_Default",
		MapObject = M["TinRock_Default6"]
	}
end

M["CopperRock_Default4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35.000000,
		PositionY = 2.000000,
		PositionZ = 37.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "CopperRock_Default4",
		Map = M._MAP,
		Resource = M["CopperRock_Default4"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "CopperRock_Default",
		MapObject = M["CopperRock_Default4"]
	}
end

M["Furnace_Default1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 59.000000,
		PositionY = 2.000000,
		PositionZ = 27.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Furnace_Default1",
		Map = M._MAP,
		Resource = M["Furnace_Default1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Furnace_Default",
		MapObject = M["Furnace_Default1"]
	}
end

M["Torch_Default11"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23.000000,
		PositionY = 0.000000,
		PositionZ = 55.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Torch_Default11",
		Map = M._MAP,
		Resource = M["Torch_Default11"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Torch_Default",
		MapObject = M["Torch_Default11"]
	}
end

M["TinRock_Default3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31.000000,
		PositionY = 2.000000,
		PositionZ = 49.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "TinRock_Default3",
		Map = M._MAP,
		Resource = M["TinRock_Default3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "TinRock_Default",
		MapObject = M["TinRock_Default3"]
	}
end

M["Torch_Default1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 75.000000,
		PositionY = 4.000000,
		PositionZ = 11.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Torch_Default1",
		Map = M._MAP,
		Resource = M["Torch_Default1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Torch_Default",
		MapObject = M["Torch_Default1"]
	}
end

M["EntranceLadder"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 79.000000,
		PositionY = 3.000000,
		PositionZ = 5.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "EntranceLadder",
		Map = M._MAP,
		Resource = M["EntranceLadder"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["EntranceLadder"]
	}
end

M["CopperRock_Default3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19.000000,
		PositionY = 2.000000,
		PositionZ = 45.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "CopperRock_Default3",
		Map = M._MAP,
		Resource = M["CopperRock_Default3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "CopperRock_Default",
		MapObject = M["CopperRock_Default3"]
	}
end

M["TinRock_Default5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35.000000,
		PositionY = 0.000000,
		PositionZ = 59.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "TinRock_Default5",
		Map = M._MAP,
		Resource = M["TinRock_Default5"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "TinRock_Default",
		MapObject = M["TinRock_Default5"]
	}
end

M["IsabelleIsland_AbandonedMine_Pillar3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 65.000000,
		PositionY = 0.000000,
		PositionZ = 61.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "IsabelleIsland_AbandonedMine_Pillar3",
		Map = M._MAP,
		Resource = M["IsabelleIsland_AbandonedMine_Pillar3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "IsabelleIsland_AbandonedMine_Pillar",
		MapObject = M["IsabelleIsland_AbandonedMine_Pillar3"]
	}
end

M["Anvil_Default1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 63.000000,
		PositionY = 2.000000,
		PositionZ = 27.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Anvil_Default1",
		Map = M._MAP,
		Resource = M["Anvil_Default1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Anvil_Default",
		MapObject = M["Anvil_Default1"]
	}
end

M["IsabelleIsland_AbandonedMine_Pillar5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 63.000000,
		PositionY = 0.000000,
		PositionZ = 75.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "IsabelleIsland_AbandonedMine_Pillar5",
		Map = M._MAP,
		Resource = M["IsabelleIsland_AbandonedMine_Pillar5"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "IsabelleIsland_AbandonedMine_Pillar",
		MapObject = M["IsabelleIsland_AbandonedMine_Pillar5"]
	}
end

M["CopperRock_Default5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23.000000,
		PositionY = 0.000000,
		PositionZ = 59.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "CopperRock_Default5",
		Map = M._MAP,
		Resource = M["CopperRock_Default5"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "CopperRock_Default",
		MapObject = M["CopperRock_Default5"]
	}
end

M["CopperRock_Default6"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 77.000000,
		PositionY = 1.000000,
		PositionZ = 33.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "CopperRock_Default6",
		Map = M._MAP,
		Resource = M["CopperRock_Default6"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "CopperRock_Default",
		MapObject = M["CopperRock_Default6"]
	}
end

M["TinRock_Default4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23.000000,
		PositionY = 2.000000,
		PositionZ = 53.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "TinRock_Default4",
		Map = M._MAP,
		Resource = M["TinRock_Default4"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "TinRock_Default",
		MapObject = M["TinRock_Default4"]
	}
end

M["Torch_Default3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 75.000000,
		PositionY = 1.000000,
		PositionZ = 33.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Torch_Default3",
		Map = M._MAP,
		Resource = M["Torch_Default3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Torch_Default",
		MapObject = M["Torch_Default3"]
	}
end

M["Torch_Default10"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 69.000000,
		PositionY = 2.000000,
		PositionZ = 33.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Torch_Default10",
		Map = M._MAP,
		Resource = M["Torch_Default10"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Torch_Default",
		MapObject = M["Torch_Default10"]
	}
end

M["Torch_Default12"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27.000000,
		PositionY = 0.000000,
		PositionZ = 65.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Torch_Default12",
		Map = M._MAP,
		Resource = M["Torch_Default12"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Torch_Default",
		MapObject = M["Torch_Default12"]
	}
end

M["Torch_Default9"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 49.000000,
		PositionY = 2.000000,
		PositionZ = 33.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Torch_Default9",
		Map = M._MAP,
		Resource = M["Torch_Default9"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Torch_Default",
		MapObject = M["Torch_Default9"]
	}
end

M["Torch_Default8"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 57.000000,
		PositionY = 0.000000,
		PositionZ = 57.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Torch_Default8",
		Map = M._MAP,
		Resource = M["Torch_Default8"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Torch_Default",
		MapObject = M["Torch_Default8"]
	}
end

M["Anvil_Default3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 63.000000,
		PositionY = 2.000000,
		PositionZ = 31.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Anvil_Default3",
		Map = M._MAP,
		Resource = M["Anvil_Default3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Anvil_Default",
		MapObject = M["Anvil_Default3"]
	}
end

M["EntranceDoor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 78.000000,
		PositionY = 3.000000,
		PositionZ = 21.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "EntranceDoor",
		Map = M._MAP,
		Resource = M["EntranceDoor"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_RumbridgeDungeon",
		MapObject = M["EntranceDoor"]
	}
end

M["BossDoor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 60.000000,
		PositionY = 2.000000,
		PositionZ = 51.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "BossDoor",
		Map = M._MAP,
		Resource = M["BossDoor"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_RumbridgeDungeon",
		MapObject = M["BossDoor"]
	}
end

M["TinRock_Default2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27.000000,
		PositionY = 4.000000,
		PositionZ = 41.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "TinRock_Default2",
		Map = M._MAP,
		Resource = M["TinRock_Default2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "TinRock_Default",
		MapObject = M["TinRock_Default2"]
	}
end

M["TinRock_Default1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19.000000,
		PositionY = 2.000000,
		PositionZ = 33.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "TinRock_Default1",
		Map = M._MAP,
		Resource = M["TinRock_Default1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "TinRock_Default",
		MapObject = M["TinRock_Default1"]
	}
end

M["Torch_Default2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 81.000000,
		PositionY = 4.000000,
		PositionZ = 11.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Torch_Default2",
		Map = M._MAP,
		Resource = M["Torch_Default2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Torch_Default",
		MapObject = M["Torch_Default2"]
	}
end

M["Anvil_Default2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 65.000000,
		PositionY = 2.000000,
		PositionZ = 27.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Anvil_Default2",
		Map = M._MAP,
		Resource = M["Anvil_Default2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Anvil_Default",
		MapObject = M["Anvil_Default2"]
	}
end

return M
