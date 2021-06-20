local M = include "Resources/Game/Maps/Rumbridge_HexLabs_Floor1/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Rumbridge_HexLabs_Floor1.Peep",
	Resource = M._MAP
}
ItsyScape.Meta.ResourceName {
	Value = "Hex Labs, Inc., Floor 1",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "A terrifying lab for the insane Techromancer, Hex.",
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
		ColorRed = 244,
		ColorGreen = 255,
		ColorBlue = 240,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.8,
		Resource = M["Light_Ambient"]
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
		ColorRed = 244,
		ColorGreen = 255,
		ColorBlue = 240,
		NearDistance = 40,
		FarDistance = 60,
		Resource = M["Light_Fog1"]
	}
end

M["Light_Mine"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 13,
		PositionY = 1,
		PositionZ = 55,
		Name = "Light_Mine",
		Map = M._MAP,
		Resource = M["Light_Mine"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_Mine"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 76,
		ColorGreen = 255,
		ColorBlue = 76,
		Resource = M["Light_Mine"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 30,
		Resource = M["Light_Mine"]
	}
end

M["Anchor_FromLeafyLake"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 3,
		PositionZ = 37,
		Name = "Anchor_FromLeafyLake",
		Map = M._MAP,
		Resource = M["Anchor_FromLeafyLake"]
	}
end

M["Emily"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 3,
		PositionZ = 29,
		Name = "Emily",
		Map = M._MAP,
		Resource = M["Emily"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Emily_Default",
		MapObject = M["Emily"]
	}

	-- ItsyScape.Meta.PeepMashinaState {
	-- 	State = "idle",
	-- 	Tree = "Resources/Game/Peeps/Emily/Emily_IdleLogic.lua",
	-- 	IsDefault = 1,
	-- 	Resource = M["Emily"]
	-- }
end

M["Hex"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 3,
		PositionZ = 21,
		Direction = 1,
		Name = "Hex",
		Map = M._MAP,
		Resource = M["Hex"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Hex",
		MapObject = M["Hex"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Hex"],
		Name = "Hex",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "Emily_Default",
		Name = "Emily",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Rumbridge_HexLabs_Floor1/Dialog/HexStart_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["Hex"] {
		TalkAction
	}
end

M["Drakkenson1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 4,
		PositionZ = 23,
		Name = "Drakkenson1",
		Map = M._MAP,
		Resource = M["Drakkenson1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Draconic_Sleeping",
		MapObject = M["Drakkenson1"]
	}
end

M["Drakkenson2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 4,
		PositionZ = 19,
		Name = "Drakkenson2",
		Map = M._MAP,
		Resource = M["Drakkenson2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Draconic_Sleeping",
		MapObject = M["Drakkenson2"]
	}
end

M["Drakkenson3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 4,
		PositionZ = 21,
		Direction = -1,
		Name = "Drakkenson3",
		Map = M._MAP,
		Resource = M["Drakkenson3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Draconic_Sleeping",
		MapObject = M["Drakkenson3"]
	}
end

M["Drakkenson4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 4,
		PositionZ = 17,
		Direction = -1,
		Name = "Drakkenson4",
		Map = M._MAP,
		Resource = M["Drakkenson4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Draconic_Sleeping",
		MapObject = M["Drakkenson4"]
	}
end

M["TV_Jakkenstone"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 50,
		PositionY = 2.5,
		PositionZ = 18.25,
		ScaleX = 4.000000,
		ScaleY = 4.000000,
		ScaleZ = 4.000000,
		Name = "TV_Jakkenstone",
		Map = M._MAP,
		Resource = M["TV_Jakkenstone"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "TV_HexLabs",
		MapObject = M["TV_Jakkenstone"]
	}
end

do
	M["Door_Elevator"] {
		ItsyScape.Action.Open() {
			Requirement {
				Resource = ItsyScape.Resource.KeyItem "HexLabs_GainedAccessToElevator",
				Count = 1
			}
		},

		ItsyScape.Action.Close()
	}
end

do
	M["Door_Mines1"] {
		ItsyScape.Action.Open(),
		ItsyScape.Action.Close()
	}

	M["Door_Mines2"] {
		ItsyScape.Action.Open(),
		ItsyScape.Action.Close()
	}

	M["Door_JakkenstoneShardAnalyzer"] {
		ItsyScape.Action.Open(),
		ItsyScape.Action.Close()
	}
end

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Hex"],
		Name = "Hex",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Emily"],
		Name = "Emily",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Rumbridge_HexLabs_Floor1/Dialog/HexMysteriousMachinationsInProgress_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.NamedMapAction {
		Name = "StartMysteriousMachinations",
		Action = TalkAction,
		Map = M._MAP
	}
end
