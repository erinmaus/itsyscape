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

M["Jenkins_Pirate"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Jenkins_Pirate",
		Map = M._MAP,
		Resource = M["Jenkins_Pirate"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins",
		MapObject = M["Jenkins_Pirate"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "cutscene",
		Tree = "Resources/Game/Maps/Ship_IsabelleIsland_PortmasterJenkins/Scripts/Jenkins_CutsceneLogic.lua",
		Resource = M["Jenkins_Pirate"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "engage",
		Tree = "Resources/Game/Maps/Ship_IsabelleIsland_PortmasterJenkins/Scripts/Jenkins_EngageLogic.lua",
		Resource = M["Jenkins_Pirate"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Ship_IsabelleIsland_PortmasterJenkins/Scripts/Jenkins_IdleLogic.lua",
		Resource = M["Jenkins_Pirate"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "cthulhu",
		Tree = "Resources/Game/Maps/Ship_IsabelleIsland_PortmasterJenkins/Scripts/Jenkins_CthulhuLogic.lua",
		Resource = M["Jenkins_Pirate"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "flee",
		Tree = "Resources/Game/Maps/Ship_IsabelleIsland_PortmasterJenkins/Scripts/Jenkins_FleeLogic.lua",
		Resource = M["Jenkins_Pirate"]
	}
end

M["Anchor_Jenkins_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29.0,
		PositionY = 5.0,
		PositionZ = 11.0,
		Direction = -1,
		Name = "Anchor_Jenkins_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Jenkins_Spawn"]
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

M["Orlando"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Orlando",
		Map = M._MAP,
		Resource = M["Orlando"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Orlando",
		MapObject = M["Orlando"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "run",
		Tree = "Resources/Game/Maps/Ship_IsabelleIsland_PortmasterJenkins/Scripts/Orlando.lua",
		Resource = M["Orlando"]
	}

	M["Orlando"] {
		ItsyScape.Action.InvisibleAttack()
	}
end

M["Rosalind"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Rosalind",
		Map = M._MAP,
		Resource = M["Rosalind"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Rosalind",
		MapObject = M["Rosalind"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IsabelliumStaff",
		Count = 1,
		Resource = M["Rosalind"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Ship_IsabelleIsland_PortmasterJenkins/Scripts/Rosalind.lua",
		Resource = M["Rosalind"]
	}

	M["Rosalind"] {
		ItsyScape.Action.InvisibleAttack()
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

M["Anchor_Orlando_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19.0,
		PositionY = 5.0,
		PositionZ = 11.0,
		Direction = 1,
		Name = "Anchor_Orlando_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Orlando_Spawn"]
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
		Direction = -1,
		Name = "Anchor_Sailor2_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Sailor2_Spawn"]
	}
end

M["Anchor_Rosalind_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7.0,
		PositionY = 5.0,
		PositionZ = 11.0,
		Direction = -1,
		Name = "Anchor_Rosalind_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Rosalind_Spawn"]
	}
end

M["SunkenChest"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39.0,
		PositionY = -1000.0,
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

M["IronCannonballPile"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 10.5,
		PositionY = 4,
		PositionZ = 11,
		RotationX = ItsyScape.Utility.Quaternion.Y_90.x,
		RotationY = ItsyScape.Utility.Quaternion.Y_90.y,
		RotationZ = ItsyScape.Utility.Quaternion.Y_90.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_90.w,
		Name = "IronCannonballPile",
		Map = M._MAP,
		Resource = M["IronCannonballPile"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "IronCannonballPile",
		MapObject = M["IronCannonballPile"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Ship_IsabelleIsland_PortmasterJenkins/Dialog/Cannonballs_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins",
		Name = "Jenkins",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["IronCannonballPile"],
		Name = "IronCannonballPile",
		Action = TalkAction
	}

	ItsyScape.Meta.ActionVerb {
		Verb = "Take",
		XProgressive = "Taking",
		Language = "en-US",
		Action = TalkAction
	}

	M["IronCannonballPile"] {
		TalkAction
	}
end

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_FarOcean2/Dialog/Jenkins_Pirate_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Jenkins_Pirate"],
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

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_PirateCaptain",
		Name = "CapnRaven",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "Cthulhu",
		Name = "Cthulhu",
		Action = TalkAction
	}

	ItsyScape.Meta.NamedMapAction {
		Name = "IntroDialog",
		Action = TalkAction,
		Map = M._MAP
	}
end
