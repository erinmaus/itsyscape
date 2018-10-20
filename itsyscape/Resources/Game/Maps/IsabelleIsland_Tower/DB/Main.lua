local M = include "Resources/Game/Maps/IsabelleIsland_Tower/DB/Default.lua"

M["Anchor_FromPort"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 16.5 * 2,
		PositionY = 1,
		PositionZ = 2.5 * 2,
		Name = "Anchor_FromPort",
		Map = M._MAP,
		Resource = M["Anchor_FromPort"]
	}
end

M["Anchor_StartGame"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 12.5 * 2,
		PositionY = 4,
		PositionZ = 11.5 * 2,
		Name = "Anchor_StartGame",
		Map = M._MAP,
		Resource = M["Anchor_StartGame"]
	}
end

M["Anchor_AbandonedMine"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 55,
		PositionY = 3,
		PositionZ = 59,
		Name = "Anchor_AbandonedMine",
		Map = M._MAP,
		Resource = M["Anchor_AbandonedMine"]
	}
end

M["Isabelle"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 14.5 * 2,
		PositionY = 4,
		PositionZ = 11.5 * 2,
		Name = "Isabelle",
		Map = M._MAP,
		Resource = M["Isabelle"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleNice",
		MapObject = M["Isabelle"]
	}
end

M["Banker"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 16.5 * 2,
		PositionY = 4,
		PositionZ = 9.5 * 2,
		Name = "Banker",
		Map = M._MAP,
		Resource = M["Banker"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "FancyBanker_Default",
		MapObject = M["Banker"]
	}
end

M["BankerChest"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 16.5 * 2,
		PositionY = 4,
		PositionZ = 8.5 * 2,
		Name = "BankerChest",
		Map = M._MAP,
		Resource = M["BankerChest"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Chest_Default",
		MapObject = M["BankerChest"]
	}

	M["BankerChest"] {
		ItsyScape.Action.Bank()
	}
end

M["Cow1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 28.5 * 2,
		PositionY = 1,
		PositionZ = 15.5 * 2,
		Name = "Cow1",
		Map = M._MAP,
		Resource = M["Cow1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Cow_Base",
		MapObject = M["Cow1"]
	}
end

do
	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_Entrance",
		Map = ItsyScape.Resource.Map "IsabelleIsland_AbandonedMine",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		Language = "en-US",
		Action = TravelAction
	}

	M["AbandonedMineLadder"] {
		TravelAction
	}
end

M["Door_Office"] {
	ItsyScape.Action.Open() {
		Requirement {
			Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToIsabelle1",
			Count = 1
		}
	},

	ItsyScape.Action.Close() {
	}
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 2,
	SizeY = 2,
	SizeZ = 2,
	MapObject = M["Door_Office"]
}

M["Door_Tower"] {
	ItsyScape.Action.Open() {
	},

	ItsyScape.Action.Close() {
	}
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 2,
	SizeY = 2,
	SizeZ = 2,
	MapObject = M["Door_Tower"]
}

M["Door_Merchant"] {
	ItsyScape.Action.Open() {
	},

	ItsyScape.Action.Close() {
	}
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 2,
	SizeY = 2,
	SizeZ = 2,
	MapObject = M["Door_Merchant"]
}

return M
