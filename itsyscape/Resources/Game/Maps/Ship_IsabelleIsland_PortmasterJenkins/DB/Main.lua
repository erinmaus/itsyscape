local M = include "Resources/Game/Maps/Ship_IsabelleIsland_PortmasterJenkins/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Ship_IsabelleIsland_PortmasterJenkins.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Portmaster Jenkins' Ship",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "A ship in very bad shape, manned by the terrified.",
	Language = "en-US",
	Resource = M._MAP
}

M["Light_Lantern1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 4,
		PositionZ = 11,
		Name = "Light_Lantern1",
		Map = M._MAP,
		Resource = M["Light_Lantern1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_Lantern1"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 200,
		ColorGreen = 160,
		ColorBlue = 66,
		Resource = M["Light_Lantern1"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 8,
		Resource = M["Light_Lantern1"]
	}
end

M["Light_Lantern2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 13,
		PositionY = 4,
		PositionZ = 11,
		Name = "Light_Lantern2",
		Map = M._MAP,
		Resource = M["Light_Lantern2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_Lantern2"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 200,
		ColorGreen = 160,
		ColorBlue = 66,
		Resource = M["Light_Lantern2"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 8,
		Resource = M["Light_Lantern2"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15.0,
		PositionY = 4.0,
		PositionZ = 11.0,
		RotationX = 0.0,
		RotationY = 0.0,
		RotationZ = 0.0,
		RotationW = 1.0,
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

M["Jenkins_Squid"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Jenkins_Squid",
		Map = M._MAP,
		Resource = M["Jenkins_Squid"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Jenkins_Squid"],
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
		MapObject = M["Jenkins_Squid"]
	}

	M["Jenkins_Squid"] {
		TalkAction
	}
end

M["Anchor_Jenkins_Squid_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.0,
		PositionY = 5.0,
		PositionZ = 11.0,
		Direction = -1,
		Name = "Anchor_Jenkins_Squid_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Jenkins_Squid_Spawn"]
	}
end

M["Sailor1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
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

M["Wizard"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Wizard",
		Map = M._MAP,
		Resource = M["Wizard"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Wizard",
		MapObject = M["Wizard"]
	}
end

M["Archer"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Archer",
		Map = M._MAP,
		Resource = M["Archer"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Archer",
		MapObject = M["Archer"]
	}
end

M["Pirate"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Pirate",
		Map = M._MAP,
		Resource = M["Pirate"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Pirate",
		MapObject = M["Pirate"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BronzeLongsword",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Wizard"
	}
end

M["Anchor_Sailor1_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21.0,
		PositionY = 5.0,
		PositionZ = 11.0,
		Direction = -1,
		Name = "Anchor_Sailor1_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Sailor1_Spawn"]
	}
end

M["Anchor_Pirate1_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19.0,
		PositionY = 5.0,
		PositionZ = 11.0,
		Direction = 1,
		Name = "Anchor_Pirate1_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Pirate1_Spawn"]
	}
end

M["Sailor2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
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

M["Anchor_Sailor2_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.0,
		PositionY = 5.0,
		PositionZ = 13.0,
		Direction = 1,
		Name = "Anchor_Sailor2_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Sailor2_Spawn"]
	}
end

M["Anchor_Pirate2_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27.0,
		PositionY = 5.0,
		PositionZ = 13.0,
		Direction = 1,
		Name = "Anchor_Pirate2_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Pirate2_Spawn"]
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
