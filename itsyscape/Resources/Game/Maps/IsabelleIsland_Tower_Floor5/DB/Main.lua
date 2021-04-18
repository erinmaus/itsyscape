local M = include "Resources/Game/Maps/IsabelleIsland_Tower_Floor5/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.IsabelleIsland_Tower_Floor5.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Isabelle Island, Tower Floor 5",
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
		PositionX = 17,
		PositionY = 0,
		PositionZ = 35,
		Name = "Anchor_DownStairs",
		Map = M._MAP,
		Resource = M["Anchor_DownStairs"]
	}
end

M["Anchor_StartGame"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 7,
		PositionZ = 27,
		Name = "Anchor_StartGame",
		Map = M._MAP,
		Resource = M["Anchor_StartGame"]
	}
end

M["UnstablePortal"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 7,
		PositionZ = 25,
		Name = "UnstablePortal",
		Map = M._MAP,
		Resource = M["UnstablePortal"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Portal_Default",
		MapObject = M["UnstablePortal"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Unstable portal",
		Language = "en-US",
		Resource = M["UnstablePortal"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The portal is unstable and can't be used.",
		Language = "en-US",
		Resource = M["UnstablePortal"]
	}
end

do
	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_UpStairs",
		Map = ItsyScape.Resource.Map "IsabelleIsland_Tower_Floor4",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		XProgressive = "Climbing-down",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_Down"] {
		TravelAction
	}
end
