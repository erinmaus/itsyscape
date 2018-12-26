local M = include "Resources/Game/Maps/Ship_IsabelleIsland_PortmasterJenkins/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Ship_IsabelleIsland_PortmasterJenkins.Peep",
	Resource = M._MAP
}

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15.0,
		PositionY = 4.0,
		PositionZ = 11.0,
		RotiationX = 0.0,
		RotiationY = 0.0,
		RotiationZ = 0.0,
		RotiationW = 1.0,
		ScaleX = 1.0,
		ScaleY = 1.0,
		ScaleZ = 1.0,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Anchor_Sailor1_Left"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 11.0,
		PositionY = 4.0,
		PositionZ = 13.0,
		Name = "Anchor_Sailor1_Left",
		Map = M._MAP,
		Resource = M["Anchor_Sailor1_Left"]
	}
end

M["Anchor_Sailor1_Right"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25.0,
		PositionY = 4.0,
		PositionZ = 13.0,
		Name = "Anchor_Sailor1_Right",
		Map = M._MAP,
		Resource = M["Anchor_Sailor1_Right"]
	}
end

M["Anchor_Sailor2_Left"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7.0,
		PositionY = 5.0,
		PositionZ = 13.0,
		Name = "Anchor_Sailor2_Left",
		Map = M._MAP,
		Resource = M["Anchor_Sailor2_Left"]
	}
end

M["Anchor_Sailor2_Right"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.0,
		PositionY = 5.0,
		PositionZ = 9.0,
		Name = "Anchor_Sailor2_Right",
		Map = M._MAP,
		Resource = M["Anchor_Sailor2_Right"]
	}
end

M["Jenkins"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.0,
		PositionY = 5.0,
		PositionZ = 11.0,
		Direction = -1,
		Name = "Jenkins",
		Map = M._MAP,
		Resource = M["Jenkins"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Jenkins"],
		Name = "Jenkins",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid",
		Name = "Squid",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_Ocean/Dialog/PortmasterJenkins_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins",
		MapObject = M["Jenkins"]
	}

	M["Jenkins"] {
		TalkAction
	}
end

M["Sailor1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21.0,
		PositionY = 5.0,
		PositionZ = 11.0,
		Direction = -1,
		Name = "Sailor1",
		Map = M._MAP,
		Resource = M["Sailor1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Ship_IsabelleIsland_PortmasterJenkins/Scripts/Sailor1_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Sailor1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Sailor_Panicked",
		MapObject = M["Sailor1"]
	}
end

M["Sailor2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.0,
		PositionY = 5.0,
		PositionZ = 13.0,
		Direction = -1,
		Name = "Sailor2",
		Map = M._MAP,
		Resource = M["Sailor2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Ship_IsabelleIsland_PortmasterJenkins/Scripts/Sailor2_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Sailor2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Sailor_Panicked",
		MapObject = M["Sailor2"]
	}
end

M["SunkenChest"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39.0,
		PositionY = -2.0,
		PositionZ = 19.0,
		Name = "SunkenChest",
		Map = M._MAP,
		Resource = M["SunkenChest"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Sunken chest",
		Language = "en-US",
		Resource = M["SunkenChest"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "I wonder what's inside?",
		Language = "en-US",
		Resource = M["SunkenChest"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "IsabelleIsland_Port_RewardChest",
		MapObject = M["SunkenChest"]
	}
end
