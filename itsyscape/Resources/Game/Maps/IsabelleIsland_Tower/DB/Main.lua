local M = include "Resources/Game/Maps/IsabelleIsland_Tower/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.IsabelleIsland_Tower.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Isabelle Island, Tower",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "The non-descript place where your adventure starts.",
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
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.6,
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
		ColorRed = 175,
		ColorGreen = 223,
		ColorBlue = 233,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 3,
		DirectionZ = 4,
		Resource = M["Light_Sun"]
	}
end

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
		PositionX = 23,
		PositionY = 4,
		PositionZ = 41,
		Name = "Anchor_StartGame",
		Map = M._MAP,
		Resource = M["Anchor_StartGame"]
	}
end

M["Anchor_AbandonedMine"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 57,
		PositionY = 6,
		PositionZ = 57,
		Name = "Anchor_AbandonedMine",
		Map = M._MAP,
		Resource = M["Anchor_AbandonedMine"]
	}
end

M["Anchor_FoggyForest"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 57,
		PositionY = 4,
		PositionZ = 27,
		Name = "Anchor_FoggyForest",
		Map = M._MAP,
		Resource = M["Anchor_FoggyForest"]
	}
end

M["Portal_FoggyForest"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 61,
		PositionY = 4,
		PositionZ = 27,
		Name = "Portal_FoggyForest",
		Map = M._MAP,
		Resource = M["Portal_FoggyForest"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 6,
		SizeY = 2,
		SizeZ = 2,
		MapObject = M["Portal_FoggyForest"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_FoggyForest"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Foggy Forest",
		Language = "en-US",
		Resource = M["Portal_FoggyForest"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_Entrance",
		Map = ItsyScape.Resource.Map "IsabelleIsland_FoggyForest",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Enter",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_FoggyForest"] {
		TravelAction
	}
end

M["Anchor_Port"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 4,
		PositionZ = 5,
		Name = "Anchor_Port",
		Map = M._MAP,
		Resource = M["Anchor_Port"]
	}
end

M["Portal_Port"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 4,
		PositionZ = 1,
		Name = "Portal_Port",
		Map = M._MAP,
		Resource = M["Portal_Port"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 2,
		SizeY = 2,
		SizeZ = 4,
		MapObject = M["Portal_Port"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_Port"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Port Isabelle",
		Language = "en-US",
		Resource = M["Portal_Port"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromTower",
		Map = ItsyScape.Resource.Map "IsabelleIsland_Port",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Enter",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_Port"] {
		TravelAction
	}
end

M["Isabelle"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 18,
		PositionY = 6,
		PositionZ = 17,
		Direction = 1,
		Name = "Isabelle",
		Map = M._MAP,
		Resource = M["Isabelle"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleNice",
		MapObject = M["Isabelle"]
	}
end

M["AdvisorGrimm"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 6,
		PositionZ = 29,
		Direction = 1,
		Name = "AdvisorGrimm",
		Map = M._MAP,
		Resource = M["AdvisorGrimm"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_AdvisorGrimm",
		MapObject = M["AdvisorGrimm"]
	}
end

M["Orlando"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 53,
		PositionY = 4.5,
		PositionZ = 55,
		Direction = -1,
		Name = "Orlando",
		Map = M._MAP,
		Resource = M["Orlando"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Orlando",
		MapObject = M["Orlando"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Orlando",
		Name = "Orlando",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_Tower/Dialog/Orlando_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["Orlando"] {
		TalkAction
	}
end

M["Banker"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 6,
		PositionZ = 15,
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
		PositionX = 37,
		PositionY = 6,
		PositionZ = 13,
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
		PositionX = 51,
		PositionY = 4,
		PositionZ = 33,
		Name = "Cow1",
		Map = M._MAP,
		Resource = M["Cow1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Cow_Base",
		MapObject = M["Cow1"]
	}
end

M["Cow2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 59,
		PositionY = 4,
		PositionZ = 37,
		Name = "Cow2",
		Map = M._MAP,
		Resource = M["Cow2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Cow_Base",
		MapObject = M["Cow2"]
	}
end

M["Bessie"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 49,
		PositionY = 4,
		PositionZ = 41,
		Direction = -1,
		Name = "Bessie",
		Map = M._MAP,
		Resource = M["Bessie"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Bessie",
		Language = "en-US",
		Resource = M["Bessie"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Cow_Base",
		MapObject = M["Bessie"]
	}
end

M["Clucker1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 4,
		PositionZ = 45,
		Direction = -1,
		Name = "Clucker1",
		Map = M._MAP,
		Resource = M["Clucker1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chicken_Base",
		MapObject = M["Clucker1"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Sanders",
		Language = "en-US",
		Resource = M["Clucker1"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Clucker1"],
		Name = "Chicken",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_Tower/Dialog/Chicken_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Discuss-politics",
		Language = "en-US",
		Action = TalkAction
	}

	M["Clucker1"] {
		TalkAction
	}
end

M["Anchor_Clucker"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
		PositionY = 4,
		PositionZ = 35,
		Direction = -1,
		Name = "Anchor_Clucker",
		Map = M._MAP,
		Resource = M["Anchor_Clucker"]
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

	M["Ladder_AbandonedMine"] {
		TravelAction
	}
end

M["Anchor_UpStairs"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 6,
		PositionZ = 37,
		Name = "Anchor_UpStairs",
		Map = M._MAP,
		Resource = M["Anchor_UpStairs"]
	}
end

do
	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_DownStairs",
		Map = ItsyScape.Resource.Map "IsabelleIsland_Tower_Floor2",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_Up"] {
		TravelAction
	}
end

M["Door_Office"] {
	ItsyScape.Action.Open(),
	ItsyScape.Action.Close()
}

M["Door_Grimm"] {
	ItsyScape.Action.Open(),
	ItsyScape.Action.Close()
}

M["Door_Tower1"] {
	ItsyScape.Action.Open() {
		Requirement {
			Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToIsabelle1",
			Count = 1
		}
	},

	ItsyScape.Action.Close()
}

M["Door_Tower2"] {
	ItsyScape.Action.Open() {
		Requirement {
			Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToIsabelle1",
			Count = 1
		}
	},

	ItsyScape.Action.Close()
}

M["Door_Tower3"] {
	ItsyScape.Action.Open() {
		Requirement {
			Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToIsabelle1",
			Count = 1
		}
	},

	ItsyScape.Action.Close()
}

do
	local SleepAction = ItsyScape.Action.Sleep()

	M["SuperComfyCouch"] {
		SleepAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Snooze",
		Language = "en-US",
		Action = SleepAction
	}
end

return M
