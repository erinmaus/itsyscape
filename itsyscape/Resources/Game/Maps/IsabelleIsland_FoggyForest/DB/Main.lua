local M = include "Resources/Game/Maps/IsabelleIsland_FoggyForest/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.IsabelleIsland_FoggyForest.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Isabelle Island, Foggy Forest",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "The resting place of Yendor's faithful human servants.",
	Language = "en-US",
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

M["LumberjackTutor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 17,
		PositionY = 5,
		PositionZ = 61,
		Name = "LumberjackTutor",
		Map = M._MAP,
		Resource = M["LumberjackTutor"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Lumberjack",
		MapObject = M["LumberjackTutor"]
	}

	ItsyScape.Meta.PeepInventoryItem {
		Item = ItsyScape.Resource.Item "Tinderbox",
		Count = 1,
		Resource = M["LumberjackTutor"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "chop",
		Tree = "Resources/Game/Maps/IsabelleIsland_FoggyForest/Scripts/Lumberjack_ChopLogic.lua",
		IsDefault = 1,
		Resource = M["LumberjackTutor"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["LumberjackTutor"],
		Name = "Lumberjack",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_FoggyForest/Dialog/Lumberjack_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["LumberjackTutor"] {
		TalkAction
	}
end

M["FletchingTutor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 67,
		PositionY = 5,
		PositionZ = 83,
		Name = "FletchingTutor",
		Map = M._MAP,
		Resource = M["FletchingTutor"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Fletcher",
		MapObject = M["FletchingTutor"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "PunyLongbow",
		Count = 1,
		Resource = M["FletchingTutor"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/IsabelleIsland_FoggyForest/Scripts/Fletcher_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["FletchingTutor"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["FletchingTutor"],
		Name = "Fletcher",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_FoggyForest/Dialog/Fletcher_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["FletchingTutor"] {
		TalkAction
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

M["Nymph1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 5,
		PositionZ = 45,
		Name = "Nymph1",
		Map = M._MAP,
		Resource = M["Nymph1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Nymph_Base_Attackable_Wand",
		MapObject = M["Nymph1"]
	}
end

M["Nymph3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 49,
		PositionY = 5,
		PositionZ = 49,
		Name = "Nymph3",
		Map = M._MAP,
		Resource = M["Nymph3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Nymph_Base_Attackable_Wand",
		MapObject = M["Nymph3"]
	}
end

M["Nymph4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 55,
		PositionY = 6,
		PositionZ = 93,
		Name = "Nymph4",
		Map = M._MAP,
		Resource = M["Nymph4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Nymph_Base_Attackable_Wand",
		MapObject = M["Nymph4"]
	}
end

M["Clucker1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 79,
		PositionY = 4,
		PositionZ = 55,
		Name = "Clucker1",
		Map = M._MAP,
		Resource = M["Clucker1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chicken_Base",
		MapObject = M["Clucker1"]
	}
end

M["Clucker2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 89,
		PositionY = 4,
		PositionZ = 59,
		Direction = -1,
		Name = "Clucker2",
		Map = M._MAP,
		Resource = M["Clucker2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chicken_Base",
		MapObject = M["Clucker2"]
	}
end

M["Clucker3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 83,
		PositionY = 5,
		PositionZ = 67,
		Direction = -1,
		Name = "Clucker3",
		Map = M._MAP,
		Resource = M["Clucker3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chicken_Base",
		MapObject = M["Clucker3"]
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
