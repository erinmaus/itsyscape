local M = include "Resources/Game/Maps/Sailing_WhalingTemple/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Sailing_WhalingTemple.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "The Whaling Temple",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "A whaling temple thought to be abandoned by Yendorians.",
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
		ColorRed = 128,
		ColorGreen = 128,
		ColorBlue = 255,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.4,
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
		ColorRed = 66,
		ColorGreen = 66,
		ColorBlue = 132,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 5,
		DirectionZ = 4,
		Resource = M["Light_Sun"]
	}
end

M["Light_Fog1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Fog1",
		Map = M._MAP,
		Resource = M["Light_Fog1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Fog_Default",
		MapObject = M["Light_Fog1"]
	}

	ItsyScape.Meta.Fog {
		ColorRed = 33,
		ColorGreen = 33,
		ColorBlue = 33,
		NearDistance = 5,
		FarDistance = 10,
		FollowTarget = 1,
		Resource = M["Light_Fog1"]
	}
end

M["Light_Fog2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Fog2",
		Map = M._MAP,
		Resource = M["Light_Fog2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Fog_Default",
		MapObject = M["Light_Fog2"]
	}

	ItsyScape.Meta.Fog {
		ColorRed = 83,
		ColorGreen = 103,
		ColorBlue = 108,
		NearDistance = 30,
		FarDistance = 60,
		Resource = M["Light_Fog2"]
	}
end

M["Anchor_InjuredYendorianArcher"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 67,
		PositionY = 5,
		PositionZ = 29,
		Name = "Anchor_InjuredYendorianArcher",
		Map = M._MAP,
		Resource = M["Anchor_InjuredYendorianArcher"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 63,
		PositionY = 3,
		PositionZ = 67,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Anchor_Ship"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 85,
		PositionY = 1.5,
		PositionZ = 83,
		Name = "Anchor_Ship",
		Map = M._MAP,
		Resource = M["Anchor_Ship"]
	}
end

M["Rowboat"] = ItsyScape.Resource.MapObject.Unique()
do
	local rotation = ItsyScape.Utility.Quaternion.fromAxisAngle(ItsyScape.Utility.Vector.UNIT_Y, math.pi / 4)

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 69,
		PositionY = 2,
		PositionZ = 73,
		RotationX = rotation.x,
		RotationY = rotation.y,
		RotationZ = rotation.z,
		RotationW = rotation.w,
		Name = "Rowboat",
		Map = M._MAP,
		Resource = M["Rowboat"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Rowboat_Default",
		MapObject = M["Rowboat"]
	}
end

M["Orlando"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 67,
		PositionY = 3,
		PositionZ = 65,
		Direction = -1,
		Name = "Orlando",
		Map = M._MAP,
		Resource = M["Orlando"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Orlando",
		MapObject = M["Orlando"]
	}
end

M["Rosalind"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 61,
		PositionY = 3,
		PositionZ = 71,
		Direction = 1,
		Name = "Rosalind",
		Map = M._MAP,
		Resource = M["Rosalind"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Rosalind",
		MapObject = M["Rosalind"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Rosalind"],
		Name = "Rosalind",
		Action = TalkAction
	}

	M["Rosalind"] {
		TalkAction
	}

	local NamedTalkActionTrees = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Trees_en-US.lua",
		Language = "en-US",
		Action = NamedTalkActionTrees
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Rosalind"],
		Name = "Rosalind",
		Action = NamedTalkActionTrees
	}

	ItsyScape.Meta.NamedPeepAction {
		Name = "TalkAboutTrees",
		Action = NamedTalkActionTrees,
		Peep = M["Rosalind"]
	}

	local NamedTalkActionFish = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Fish_en-US.lua",
		Language = "en-US",
		Action = NamedTalkActionFish
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Rosalind"],
		Name = "Rosalind",
		Action = NamedTalkActionFish
	}

	ItsyScape.Meta.NamedPeepAction {
		Name = "TalkAboutFish",
		Action = NamedTalkActionFish,
		Peep = M["Rosalind"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "follow",
		Tree = "Resources/Game/Maps/Sailing_WhalingTemple/Scripts/Rosalind_FollowLogic.lua",
		Resource = M["Rosalind"]
	}
end

M["Jenkins"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 65,
		PositionY = 3,
		PositionZ = 67,
		Direction = -1,
		Name = "Jenkins",
		Map = M._MAP,
		Resource = M["Jenkins"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins",
		MapObject = M["Jenkins"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Jenkins_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Jenkins"],
		Name = "Jenkins",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Orlando"],
		Name = "Orlando",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Rosalind"],
		Name = "Rosalind",
		Action = TalkAction
	}

	M["Jenkins"] {
		TalkAction
	}
end

M["TrapDoor_ToMine"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 5,
		PositionZ = 31,
		Name = "TrapDoor_ToMine",
		Map = M._MAP,
		Resource = M["TrapDoor_ToMine"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "TrapDoor_Default",
		MapObject = M["TrapDoor_ToMine"]
	}

	local TravelAction = ItsyScape.Action.Travel() {
		Requirement {
			Resource = ItsyScape.Resource.KeyItem "PreTutorial_CookedFish",
			Count = 1
		}
	}

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromFish",
		Map = ItsyScape.Resource.Map "Sailing_WhalingTemple_Underground",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Descend",
		XProgressive = "Descending",
		Language = "en-US",
		Action = TravelAction
	}

	M["TrapDoor_ToMine"] {
		TravelAction
	}
end

M["Anchor_FromMine"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 5,
		PositionZ = 33,
		Name = "Anchor_FromMine",
		Map = M._MAP,
		Resource = M["Anchor_FromMine"]
	}
end

M["BossDoor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 76,
		PositionY = 5,
		PositionZ = 53,
		Name = "BossDoor",
		Map = M._MAP,
		Resource = M["BossDoor"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Base",
		MapObject = M["BossDoor"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Yendorian door",
		Language = "en-US",
		Resource = M["BossDoor"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Doesn't look like there's a simple way to open this door.",
		Language = "en-US",
		Resource = M["BossDoor"]
	}
end

M["Sardine1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 2,
		PositionZ = 39,
		Name = "Sardine1",
		Map = M._MAP,
		Resource = M["Sardine1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Sardine_Default",
		MapObject = M["Sardine1"]
	}
end

M["Sardine2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 2,
		PositionZ = 41,
		Name = "Sardine2",
		Map = M._MAP,
		Resource = M["Sardine2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Sardine_Default",
		MapObject = M["Sardine2"]
	}
end

M["Sardine3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 2,
		PositionZ = 37,
		Name = "Sardine3",
		Map = M._MAP,
		Resource = M["Sardine3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Sardine_Default",
		MapObject = M["Sardine3"]
	}
end

M["Maggot1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 4,
		PositionZ = 51,
		Direction = -1,
		Name = "Maggot1",
		Map = M._MAP,
		Resource = M["Maggot1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PreTutorial_Maggot",
		MapObject = M["Maggot1"],
		DoesRespawn = 1
	}
end

M["Maggot2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 4,
		PositionZ = 45,
		Direction = 1,
		Name = "Maggot2",
		Map = M._MAP,
		Resource = M["Maggot2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PreTutorial_Maggot",
		MapObject = M["Maggot2"],
		DoesRespawn = 1
	}
end

M["Maggot3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 49,
		PositionY = 4,
		PositionZ = 49,
		Direction = -1,
		Name = "Maggot3",
		Map = M._MAP,
		Resource = M["Maggot3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PreTutorial_Maggot",
		MapObject = M["Maggot3"],
		DoesRespawn = 1
	}
end

M["Passage_ToFishingArea"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_ToFishingArea",
		Map = M._MAP,
		Resource = M["Passage_ToFishingArea"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 38,
		Z1 = 50,
		X2 = 44,
		Z2 = 58,
		Map = M._MAP,
		Resource = M["Passage_ToFishingArea"]
	}
end

M["Passage_FishingArea"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_FishingArea",
		Map = M._MAP,
		Resource = M["Passage_FishingArea"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 36,
		Z1 = 46,
		X2 = 46,
		Z2 = 50,
		Map = M._MAP,
		Resource = M["Passage_FishingArea"]
	}
end

M["Passage_Trees"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_Trees",
		Map = M._MAP,
		Resource = M["Passage_Trees"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 32,
		Z1 = 60,
		X2 = 50,
		Z2 = 76,
		Map = M._MAP,
		Resource = M["Passage_Trees"]
	}
end

M["Anchor_FromFishingArea"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41,
		PositionY = 4,
		PositionZ = 63,
		Name = "Anchor_FromFishingArea",
		Map = M._MAP,
		Resource = M["Anchor_FromFishingArea"]
	}
end
