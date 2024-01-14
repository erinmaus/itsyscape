local M = include "Resources/Game/Maps/Rumbridge_Castle_Dungeon/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Rumbridge_Castle_Dungeon.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Rumbridge Castle, Dungeon",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Horrible but not unusual.",
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
		ColorGreen = 173,
		ColorBlue = 119,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.3,
		Resource = M["Light_Ambient"]
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
		ColorRed = 0,
		ColorGreen = 0,
		ColorBlue = 0,
		NearDistance = 10,
		FarDistance = 15,
		FollowTarget = 1,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_SuperSupperSaboteurVictim"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 3,
		PositionY = 0,
		PositionZ = 9,
		Name = "Anchor_SuperSupperSaboteurVictim",
		Map = M._MAP,
		Resource = M["Anchor_SuperSupperSaboteurVictim"]
	}
end

M["ChefAllon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "ChefAllon",
		Map = M._MAP,
		Resource = M["ChefAllon"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "ChefAllon",
		MapObject = M["ChefAllon"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["ChefAllon"],
		Name = "ChefAllon",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Rumbridge_Castle_Dungeon/Dialog/ChefAllon_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	local ShopAction = ItsyScape.Action.Shop() {
		Requirement {
			Resource = ItsyScape.Resource.Quest "SuperSupperSaboteur",
			Count = 1
		}
	}

	ItsyScape.Meta.ShopTarget {
		Resource = ItsyScape.Resource.Shop "Special_CookingStore_Allon",
		Action = ShopAction
	}

	ItsyScape.Meta.PropAnchor {
		OffsetI = 0,
		OffsetJ = 1,
		Resource = M["ChefAllon"]
	}

	M["ChefAllon"] {
		TalkAction,
		ShopAction
	}
end

M["Oliver"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Oliver",
		Map = M._MAP,
		Resource = M["Oliver"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Oliver",
		MapObject = M["Oliver"]
	}

	M["Oliver"] {
		ItsyScape.Action.Pet()
	}
end


M["Lyra"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Lyra",
		Map = M._MAP,
		Resource = M["Lyra"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Lyra",
		MapObject = M["Lyra"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Lyra"],
		Name = "Lyra",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Oliver"],
		Name = "Oliver",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Rumbridge_Castle_Dungeon/Dialog/Lyra_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.PropAnchor {
		OffsetI = 0,
		OffsetJ = 1,
		Resource = M["Lyra"]
	}

	M["Lyra"] {
		TalkAction
	}
end

local IronGateOpenAction = ItsyScape.Action.Open() {
	Requirement {
		Resource = ItsyScape.Resource.Item "Rumbridge_DungeonKey",
		Count = 1
	}
}

M["Door_IronGate1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 3,
		PositionY = 0,
		PositionZ = 11,
		Name = "Door_IronGate1",
		Map = M._MAP,
		Resource = M["Door_IronGate1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_IronGate",
		MapObject = M["Door_IronGate1"]
	}

	M["Door_IronGate1"] {
		IronGateOpenAction
	}
end

M["Door_IronGate2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 13,
		PositionY = 0,
		PositionZ = 11,
		Name = "Door_IronGate2",
		Map = M._MAP,
		Resource = M["Door_IronGate2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_IronGate",
		MapObject = M["Door_IronGate2"]
	}

	M["Door_IronGate2"] {
		IronGateOpenAction
	}
end

M["Door_IronGate3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 0,
		PositionZ = 11,
		Name = "Door_IronGate3",
		Map = M._MAP,
		Resource = M["Door_IronGate3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_IronGate",
		MapObject = M["Door_IronGate3"]
	}

	M["Door_IronGate3"] {
		IronGateOpenAction
	}
end

M["Door_IronGate4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 0,
		PositionZ = 11,
		Name = "Door_IronGate4",
		Map = M._MAP,
		Resource = M["Door_IronGate4"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_IronGate",
		MapObject = M["Door_IronGate4"]
	}

	M["Door_IronGate4"] {
		IronGateOpenAction
	}
end

M["Door_IronGate5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 0,
		PositionZ = 11,
		Name = "Door_IronGate5",
		Map = M._MAP,
		Resource = M["Door_IronGate5"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_IronGate",
		MapObject = M["Door_IronGate5"]
	}

	M["Door_IronGate5"] {
		IronGateOpenAction
	}
end

M["Door_IronGate6"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 55,
		PositionY = 0,
		PositionZ = 11,
		Name = "Door_IronGate6",
		Map = M._MAP,
		Resource = M["Door_IronGate6"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_IronGate",
		MapObject = M["Door_IronGate6"]
	}

	M["Door_IronGate6"] {
		IronGateOpenAction
	}
end

M["Ladder_ToCave"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 61,
		PositionY = -2,
		PositionZ = 27,
		Name = "Ladder_ToCave",
		Map = M._MAP,
		Resource = M["Ladder_ToCave"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["Ladder_ToCave"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromDungeon",
		Map = ItsyScape.Resource.Map "Rumbridge_Castle_CaveFloor1",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		XProgressive = "Climbing-down",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_ToCave"] {
		TravelAction
	}
end

M["SpiralStaircase"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 5,
		PositionY = 0,
		PositionZ = 27,
		Name = "SpiralStaircase",
		Map = M._MAP,
		Resource = M["SpiralStaircase"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "SpiralStaircase_Default",
		MapObject = M["SpiralStaircase"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromDungeon",
		Map = ItsyScape.Resource.Map "Rumbridge_Castle",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["SpiralStaircase"] {
		TravelAction
	}
end

M["Anchor_FromGroundFloor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7,
		PositionY = 0,
		PositionZ = 27,
		Name = "Anchor_FromGroundFloor",
		Map = M._MAP,
		Resource = M["Anchor_FromGroundFloor"]
	}
end

M["Anchor_FromCave"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 59,
		PositionY = 0,
		PositionZ = 27,
		Name = "Anchor_FromCave",
		Map = M._MAP,
		Resource = M["Anchor_FromCave"]
	}
end

M["Boop1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 11,
		PositionY = 0,
		PositionZ = 21,
		Name = "Boop1",
		Map = M._MAP,
		Resource = M["Boop1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Boop",
		MapObject = M["Boop1"]
	}
end

M["Boop2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 0,
		PositionZ = 15,
		Name = "Boop2",
		Map = M._MAP,
		Resource = M["Boop2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Boop",
		MapObject = M["Boop2"]
	}
end

M["Boop3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 0,
		PositionZ = 25,
		Name = "Boop3",
		Map = M._MAP,
		Resource = M["Boop3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Boop",
		MapObject = M["Boop3"]
	}
end

M["Boop4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
		PositionY = 0,
		PositionZ = 7,
		Name = "Boop4",
		Map = M._MAP,
		Resource = M["Boop4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Boop",
		MapObject = M["Boop4"]
	}
end

M["Boop5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 61,
		PositionY = 0,
		PositionZ = 17,
		Name = "Boop5",
		Map = M._MAP,
		Resource = M["Boop5"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Boop",
		MapObject = M["Boop5"]
	}
end

M["Guard1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 11,
		PositionY = 0,
		PositionZ = 17,
		Name = "Guard1",
		Map = M._MAP,
		Resource = M["Guard1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Guard_RumbridgeDungeon",
		MapObject = M["Guard1"]
	}
end

M["Guard2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 0,
		PositionZ = 17,
		Name = "Guard2",
		Map = M._MAP,
		Resource = M["Guard2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Guard_RumbridgeDungeon",
		MapObject = M["Guard2"]
	}
end

M["Guard3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47,
		PositionY = 0,
		PositionZ = 17,
		Name = "Guard3",
		Map = M._MAP,
		Resource = M["Guard3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Guard_RumbridgeDungeon",
		MapObject = M["Guard3"]
	}
end
