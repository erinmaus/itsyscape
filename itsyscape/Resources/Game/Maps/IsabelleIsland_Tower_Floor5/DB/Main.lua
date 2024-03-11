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

M["Anchor_Grimm"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19,
		PositionY = 0,
		PositionZ = 35,
		Direction = 1,
		Name = "Anchor_Grimm",
		Map = M._MAP,
		Resource = M["Anchor_Grimm"]
	}
end

M["Grimm"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Grimm",
		Map = M._MAP,
		Resource = M["Grimm"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_AdvisorGrimm",
		MapObject = M["Grimm"]
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

M["Anchor_GrimmOnTower"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 7,
		PositionZ = 27,
		Name = "Anchor_GrimmOnTower",
		Map = M._MAP,
		Resource = M["Anchor_GrimmOnTower"]
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
		Prop = ItsyScape.Resource.Prop "Portal_Antilogika",
		MapObject = M["UnstablePortal"]
	}

	M["UnstablePortal"] {
		ItsyScape.Action.Teleport_Antilogika() {
			Requirement {
				Resource = ItsyScape.Resource.Quest "CalmBeforeTheStorm",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.AntilogikaTeleportDestination {
		ReturnAnchor = "Anchor_StartGame",
		ReturnMap = M._MAP,
		Portal = M["UnstablePortal"]
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

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Grimm"],
		Name = "Grimm",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_Tower_Floor5/Dialog/Grimm1_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.NamedMapAction {
		Name = "GrimmYell1",
		Action = TalkAction,
		Map = M._MAP
	}
end

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Grimm"],
		Name = "Grimm",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_Tower_Floor5/Dialog/Grimm2_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.NamedMapAction {
		Name = "GrimmYell2",
		Action = TalkAction,
		Map = M._MAP
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "IsabelleIsland_Tower_Floor5_Introduction"
end
