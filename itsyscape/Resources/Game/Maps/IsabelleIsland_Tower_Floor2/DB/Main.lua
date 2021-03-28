local M = include "Resources/Game/Maps/IsabelleIsland_Tower_Floor2/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.IsabelleIsland_Tower_Floor2.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Isabelle Island, Tower Floor 2",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "The non-descript place where your adventure starts.",
	Language = "en-US",
	Resource = M._MAP
}

M["Anchor_DownStairs"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 0,
		PositionZ = 37,
		Name = "Anchor_DownStairs",
		Map = M._MAP,
		Resource = M["Anchor_DownStairs"]
	}
end

M["Anchor_UpStairs"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 0,
		PositionZ = 35,
		Name = "Anchor_UpStairs",
		Map = M._MAP,
		Resource = M["Anchor_UpStairs"]
	}
end

do
	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_DownStairs",
		Map = ItsyScape.Resource.Map "IsabelleIsland_Tower_Floor3",
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

do
	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_UpStairs",
		Map = ItsyScape.Resource.Map "IsabelleIsland_Tower",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_Down"] {
		TravelAction
	}
end
