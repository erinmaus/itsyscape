local M = include "Resources/Game/Maps/IsabelleIsland_FoggyForest/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.IsabelleIsland_FoggyForest.Peep",
	Resource = M._MAP
}

M["YendorianPriest"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 85,
		PositionY = 5,
		PositionZ = 19,
		Name = "YendorianPriest",
		Map = M._MAP,
		Resource = M["YendorianPriest"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendorian_Base",
		MapObject = M["YendorianPriest"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Yendorian priest Uuly'lth",
		Language = "en-US",
		Resource = M["YendorianPriest"]
	}

	local ShopAction = ItsyScape.Action.Shop()

	ItsyScape.Meta.ShopTarget {
		Resource = ItsyScape.Resource.Shop "IsabelleIsland_FoggyForest_YendorianIncenseShop",
		Action = ShopAction
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["YendorianPriest"],
		Name = "Priest",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_FoggyForest/Dialog/YendorianPriest_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["YendorianPriest"] {
		TalkAction,
		ShopAction,
		ItsyScape.Action.Attack()
	}
end

M["Zombi1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 5,
		PositionZ = 15,
		Name = "Zombi1",
		Map = M._MAP,
		Resource = M["Zombi1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Zombi1"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Chris",
		Language = "en-US",
		Resource = M["Zombi1"]
	}
end

M["Zombi2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 5,
		PositionZ = 29,
		Name = "Zombi2",
		Map = M._MAP,
		Resource = M["Zombi2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Zombi2"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Brandon",
		Language = "en-US",
		Resource = M["Zombi2"]
	}
end

M["Zombi3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 5,
		PositionZ = 23,
		Name = "Zombi3",
		Map = M._MAP,
		Resource = M["Zombi3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Zombi3"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Edgar",
		Language = "en-US",
		Resource = M["Zombi3"]
	}
end

M["Zombi4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 5,
		PositionZ = 27,
		Name = "Zombi4",
		Map = M._MAP,
		Resource = M["Zombi4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Zombi4"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Neil",
		Language = "en-US",
		Resource = M["Zombi4"]
	}
end

M["Zombi4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 87,
		PositionY = 5,
		PositionZ = 75,
		Name = "Zombi4",
		Map = M._MAP,
		Resource = M["Zombi4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Zombi4"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Elias",
		Language = "en-US",
		Resource = M["Zombi4"]
	}
end

M["Zombi4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 83,
		PositionY = 5,
		PositionZ = 89,
		Name = "Zombi4",
		Map = M._MAP,
		Resource = M["Zombi4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Zombi4"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Matthew",
		Language = "en-US",
		Resource = M["Zombi4"]
	}
end

M["Zombi5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 89,
		PositionY = 5,
		PositionZ = 91,
		Name = "Zombi5",
		Map = M._MAP,
		Resource = M["Zombi5"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Zombi5"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Pavel",
		Language = "en-US",
		Resource = M["Zombi5"]
	}
end

M["Zombi6"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 81,
		PositionY = 5,
		PositionZ = 79,
		Name = "Zombi6",
		Map = M._MAP,
		Resource = M["Zombi6"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Zombi6"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Gideon",
		Language = "en-US",
		Resource = M["Zombi6"]
	}
end

M["Anchor_SpawnNorthWest"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 5,
		PositionZ = 39,
		Name = "Anchor_SpawnNorthWest",
		Map = M._MAP,
		Resource = M["Anchor_SpawnNorthWest"]
	}
end

M["Anchor_SpawnSouthEast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 79,
		PositionY = 5,
		PositionZ = 77,
		Name = "Anchor_SpawnSouthEast",
		Map = M._MAP,
		Resource = M["Anchor_SpawnSouthEast"]
	}
end

M["Anchor_SpawnClearing"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 85,
		PositionY = 5,
		PositionZ = 59,
		Name = "Anchor_SpawnClearing",
		Map = M._MAP,
		Resource = M["Anchor_SpawnClearing"]
	}
end
