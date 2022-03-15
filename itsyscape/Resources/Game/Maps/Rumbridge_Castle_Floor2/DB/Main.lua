local M = include "Resources/Game/Maps/Rumbridge_Castle_Floor2/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Rumbridge_Castle_Floor2.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Rumbridge, Castle, Floor 2",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Throne room for the Earl.",
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

M["Ladder_ToAttic"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
		PositionY = 0,
		PositionZ = 13,
		Name = "Ladder_ToAttic",
		Map = M._MAP,
		Resource = M["Ladder_ToAttic"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["Ladder_ToAttic"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromLadder",
		Map = ItsyScape.Resource.Map "Rumbridge_Castle_Floor3",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_ToAttic"] {
		TravelAction
	}
end

M["Portal_Ladder"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 49,
		PositionY = 0,
		PositionZ = 13,
		Name = "Portal_Ladder",
		Map = M._MAP,
		Resource = M["Portal_Ladder"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1.5,
		SizeY = 1,
		SizeZ = 1.5,
		MapObject = M["Portal_Ladder"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_Ladder"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Ladder",
		Language = "en-US",
		Resource = M["Portal_Ladder"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "I wonder where this leads?",
		Language = "en-US",
		Resource = M["Portal_Ladder"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromLadder",
		Map = ItsyScape.Resource.Map "Rumbridge_Castle_Floor1",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		XProgressive = "Climbing-down",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_Ladder"] {
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

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromStairs",
		Map = ItsyScape.Resource.Map "Rumbridge_Castle_Floor1",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		XProgressive = "Climbing-down",
		Language = "en-US",
		Action = TravelAction
	}

	M["SpiralStaircase"] {
		TravelAction
	}
end
