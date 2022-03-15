local M = include "Resources/Game/Maps/Rumbridge_Castle_Floor3/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Rumbridge_Castle_Floor3.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Rumbridge, Castle, Attic",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "An attic - what lurks up here?",
	Language = "en-US",
	Resource = M._MAP
}

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

M["Portal_Ladder"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
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
		Map = ItsyScape.Resource.Map "Rumbridge_Castle_Floor2",
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

M["Sleepyrosy"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 1,
		PositionZ = 15,
		Name = "Sleepyrosy",
		Map = M._MAP,
		Resource = M["Sleepyrosy"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Sleepyrosy",
		MapObject = M["Sleepyrosy"]
	}
end
