local M = include "Resources/Game/Maps/Minigame_ChickenPolitics/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Minigame_ChickenPolitics.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Chicken Politickin'",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "They come from the sky!",
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

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 17,
		PositionY = 4,
		PositionZ = 27,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Farmer"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 13,
		PositionY = 4,
		PositionZ = 23,
		Name = "Farmer",
		Map = M._MAP,
		Resource = M["Farmer"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "ChickenPolitickin_Farmer",
		MapObject = M["Farmer"]
	}

	local TalkAction = ItsyScape.Action.Talk()
	local QuickTalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.ActionVerb {
		Value = "Quick-Start",
		Language = "en-US",
		Action = QuickTalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Farmer"],
		Name = "Farmer",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Minigame_ChickenPolitics/Dialog/Farmer_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Farmer"],
		Name = "Farmer",
		Action = QuickTalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Minigame_ChickenPolitics/Dialog/FarmerStart_en-US.lua",
		Language = "en-US",
		Action = QuickTalkAction
	}

	M["Farmer"] {
		TalkAction,
		QuickTalkAction
	}
end

M["ScaredFarmer"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 13,
		PositionY = 4,
		PositionZ = 15,
		Name = "ScaredFarmer",
		Map = M._MAP,
		Resource = M["ScaredFarmer"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "ChickenPolitickin_Farmer",
		MapObject = M["ScaredFarmer"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Minigame_ChickenPolitics/Scripts/Farmer_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["ScaredFarmer"]
	}
end

M["Anchor_1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 13,
		PositionY = 4,
		PositionZ = 15,
		Name = "Anchor_1",
		Map = M._MAP,
		Resource = M["Anchor_1"]
	}
end

M["Anchor_2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 5,
		PositionZ = 27,
		Name = "Anchor_2",
		Map = M._MAP,
		Resource = M["Anchor_2"]
	}
end

M["Anchor_3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19,
		PositionY = 4,
		PositionZ = 11,
		Name = "Anchor_3",
		Map = M._MAP,
		Resource = M["Anchor_3"]
	}
end

M["Anchor_4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 5,
		PositionY = 5,
		PositionZ = 9,
		Name = "Anchor_4",
		Map = M._MAP,
		Resource = M["Anchor_4"]
	}
end

M["Anchor_5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 5,
		PositionY = 5,
		PositionZ = 25,
		Name = "Anchor_5",
		Map = M._MAP,
		Resource = M["Anchor_5"]
	}
end
