local M = include "Resources/Game/Maps/Rumbridge_Castle_Dungeon/DB/Default.lua"

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