local M = include "Resources/Game/Maps/Rumbridge_Castle_Floor1/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Rumbridge_Castle_Floor1.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Rumbridge, Castle, Floor 1",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Sleeping quarters of the Earl and his guests.",
	Language = "en-US",
	Resource = M._MAP
}

M["Anchor_FromStairs"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 0,
		PositionZ = 15,
		Name = "Anchor_FromStairs",
		Map = M._MAP,
		Resource = M["Anchor_FromStairs"]
	}
end

M["Anchor_FromLadder"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47,
		PositionY = 0,
		PositionZ = 13,
		Name = "Anchor_FromLadder",
		Map = M._MAP,
		Resource = M["Anchor_FromLadder"]
	}
end

M["Ladder_ToThroneRoom"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 49,
		PositionY = 0,
		PositionZ = 13,
		Name = "Ladder_ToThroneRoom",
		Map = M._MAP,
		Resource = M["Ladder_ToThroneRoom"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["Ladder_ToThroneRoom"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromLadder",
		Map = ItsyScape.Resource.Map "Rumbridge_Castle_Floor2",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_ToThroneRoom"] {
		TravelAction
	}
end

M["SpiralStaircase"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 0,
		PositionZ = 13,
		Name = "SpiralStaircase",
		Map = M._MAP,
		Resource = M["SpiralStaircase"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "SpiralStaircase_Default",
		MapObject = M["SpiralStaircase"]
	}

	local TravelActionUp = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromStairs",
		Map = ItsyScape.Resource.Map "Rumbridge_Castle_Floor2",
		Action = TravelActionUp
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelActionUp
	}

	M["SpiralStaircase"] {
		TravelActionUp
	}

	local TravelActionDown = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromFloor1",
		Map = ItsyScape.Resource.Map "Rumbridge_Castle",
		Action = TravelActionDown
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		XProgressive = "Climbing-down",
		Language = "en-US",
		Action = TravelActionDown
	}

	M["SpiralStaircase"] {
		TravelActionDown
	}
end

M["Door_ToAttic1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47,
		PositionY = 0,
		PositionZ = 19,
		Name = "Door_ToAttic1",
		Map = M._MAP,
		Resource = M["Door_ToAttic1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_IronGate",
		MapObject = M["Door_ToAttic1"]
	}

	M["Door_ToAttic1"] {
		ItsyScape.Action.Open() {
			Requirement {
				Resource = ItsyScape.Resource.Item "Rumbridge_Castle_SecretAtticKey",
				Count = 1
			}
		},
	}
end

M["Door_ToAttic2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 0,
		PositionZ = 15,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = -0.707107,
		Name = "Door_ToAttic2",
		Map = M._MAP,
		Resource = M["Door_ToAttic2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_IronGate",
		MapObject = M["Door_ToAttic2"]
	}

	M["Door_ToAttic2"] {
		ItsyScape.Action.Open() {
			Requirement {
				Resource = ItsyScape.Resource.Item "Rumbridge_Castle_SecretAtticKey",
				Count = 1
			}
		},
	}
end
