local M = include "Resources/Game/Maps/IsabelleIsland_FoggyForest/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.IsabelleIsland_FoggyForest.Peep",
	Resource = M._MAP
}

M["Light_Ambient"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Ambient",
		Map = M._MAP,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "AmbientLight_Default",
		MapObject = M["Light_Ambient"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 231,
		ColorGreen = 168,
		ColorBlue = 194,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.8,
		Resource = M["Light_Ambient"]
	}
end

M["Light_Sun"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Sun",
		Map = M._MAP,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "DirectionalLight_Default",
		MapObject = M["Light_Sun"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 234,
		ColorGreen = 162,
		ColorBlue = 33,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 3,
		DirectionZ = 4,
		Resource = M["Light_Sun"]
	}
end

M["Light_Fog"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Fog",
		Map = M._MAP,
		Resource = M["Light_Fog"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Fog_Default",
		MapObject = M["Light_Fog"]
	}

	ItsyScape.Meta.Fog {
		ColorRed = 81,
		ColorGreen = 16,
		ColorBlue = 117,
		NearDistance = 20,
		FarDistance = 60,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_Entrance"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7,
		PositionY = 5,
		PositionZ = 59,
		Name = "Anchor_Entrance",
		Map = M._MAP,
		Resource = M["Anchor_Entrance"]
	}
end

M["Portal_Tower"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 3,
		PositionY = 5,
		PositionZ = 59,
		Name = "Portal_Tower",
		Map = M._MAP,
		Resource = M["Portal_Tower"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 6,
		SizeY = 2,
		SizeZ = 2,
		MapObject = M["Portal_Tower"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_Tower"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Isabelle Tower",
		Language = "en-US",
		Resource = M["Portal_Tower"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FoggyForest",
		Map = ItsyScape.Resource.Map "IsabelleIsland_Tower",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Return",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_Tower"] {
		TravelAction
	}
end

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
