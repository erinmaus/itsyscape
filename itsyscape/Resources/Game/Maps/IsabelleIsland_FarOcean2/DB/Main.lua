local M = include "Resources/Game/Maps/IsabelleIsland_FarOcean2/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.IsabelleIsland_FarOcean2.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Edge of Rh'lor",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Under the oceans of Rh'lor, Cthulhu sleeps.",
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
		Ambience = 1,
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
		ColorBlue = 66,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 5,
		DirectionZ = 4,
		Resource = M["Light_Sun"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 1,
		PositionY = 0,
		PositionZ = 1,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["CameraDolly"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "CameraDolly",
		Map = M._MAP,
		Resource = M["CameraDolly"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CameraDolly",
		MapObject = M["CameraDolly"]
	}
end

M["Anchor_Cthulhu_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 32,
		PositionY = 0,
		PositionZ = 48,
		Map = M._MAP,
		Name = "Anchor_Cthulhu_Spawn",
		Resource = M["Anchor_Cthulhu_Spawn"]
	}
end

M["Anchor_Squid_Spawn1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 24,
		PositionY = 0,
		PositionZ = 56,
		Map = M._MAP,
		Name = "Anchor_Squid_Spawn1",
		Resource = M["Anchor_Squid_Spawn1"]
	}
end

M["Anchor_Squid_Spawn2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 40,
		PositionY = 0,
		PositionZ = 56,
		Map = M._MAP,
		Name = "Anchor_Squid_Spawn2",
		Resource = M["Anchor_Squid_Spawn2"]
	}
end

M["Anchor_Squid_Spawn3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 36,
		PositionY = 0,
		PositionZ = 40,
		Map = M._MAP,
		Name = "Anchor_Squid_Spawn3",
		Resource = M["Anchor_Squid_Spawn3"]
	}
end

M["Cthulhu"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Cthulhu",
		Map = M._MAP,
		Resource = M["Cthulhu"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Cthulhu",
		MapObject = M["Cthulhu"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		IsDefault = 1,
		Tree = "Resources/Game/Maps/IsabelleIsland_FarOcean2/Scripts/Cthulhu.lua",
		Resource = M["Cthulhu"]
	}

	M["Cthulhu"] {
		ItsyScape.Action.InvisibleAttack()
	}
end

M["UndeadSquid"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "UndeadSquid",
		Map = M._MAP,
		Resource = M["UndeadSquid"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Undead squid",
		Language = "en-US",
		Resource = M["UndeadSquid"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Loyal servants to Cthulhu and its master, Yendor.",
		Language = "en-US",
		Resource = M["UndeadSquid"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid",
		MapObject = M["UndeadSquid"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "spawn",
		Tree = "Resources/Game/Maps/IsabelleIsland_FarOcean2/Scripts/UndeadSquid.lua",
		IsDefault = 1,
		Resource = M["UndeadSquid"]
	}

	ItsyScape.Meta.PeepHealth {
		Hitpoints = 15,
		Resource = M["UndeadSquid"]
	}

	M["UndeadSquid"] {
		ItsyScape.Action.InvisibleAttack()
	}
end

M["Anchor_PirateShip_Cthulhu"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 16,
		Map = M._MAP,
		Name = "Anchor_PirateShip_Cthulhu",
		Resource = M["Anchor_PirateShip_Cthulhu"]
	}
end

M["Anchor_PirateShip_1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 32,
		PositionY = 0,
		PositionZ = 16,
		Map = M._MAP,
		Name = "Anchor_PirateShip_1",
		Resource = M["Anchor_PirateShip_1"]
	}
end

M["Anchor_JenkinsShip_Cthulhu"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 64,
		PositionY = 0,
		PositionZ = 80,
		Map = M._MAP,
		Name = "Anchor_JenkinsShip_Cthulhu",
		Resource = M["Anchor_JenkinsShip_Cthulhu"]
	}
end

M["Anchor_JenkinsShip_1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 56,
		PositionY = 0,
		PositionZ = 64,
		Map = M._MAP,
		Name = "Anchor_JenkinsShip_1",
		Resource = M["Anchor_JenkinsShip_1"]
	}
end

M["Anchor_JenkinsShip_2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 64,
		Map = M._MAP,
		Name = "Anchor_JenkinsShip_2",
		Resource = M["Anchor_JenkinsShip_2"]
	}
end

M["Anchor_JenkinsShip_3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Map = M._MAP,
		Name = "Anchor_JenkinsShip_3",
		Resource = M["Anchor_JenkinsShip_3"]
	}
end

M["Anchor_JenkinsShip_4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 32,
		PositionY = 0,
		PositionZ = 80,
		Map = M._MAP,
		Name = "Anchor_JenkinsShip_4",
		Resource = M["Anchor_JenkinsShip_4"]
	}
end

M["Anchor_JenkinsShip_Flee1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = -64,
		PositionY = 0,
		PositionZ = -64,
		Map = M._MAP,
		Name = "Anchor_JenkinsShip_Flee1",
		Resource = M["Anchor_JenkinsShip_Flee1"]
	}
end

M["Anchor_JenkinsShip_Flee2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 64,
		PositionY = 0,
		PositionZ = -64,
		Map = M._MAP,
		Name = "Anchor_JenkinsShip_Flee2",
		Resource = M["Anchor_JenkinsShip_Flee2"]
	}
end

M["Anchor_JenkinsShip_Flee3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 64,
		PositionY = 0,
		PositionZ = 64,
		Map = M._MAP,
		Name = "Anchor_JenkinsShip_Flee3",
		Resource = M["Anchor_JenkinsShip_Flee3"]
	}
end

M["Anchor_JenkinsShip_Flee4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 64,
		Map = M._MAP,
		Name = "Anchor_JenkinsShip_Flee4",
		Resource = M["Anchor_JenkinsShip_Flee4"]
	}
end

M["Water"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Water",
		Map = M._MAP,
		Resource = M["Water"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "EndlessWater",
		MapObject = M["Water"]
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "IsabelleIsland_FarOcean2_Intro"

	ItsyScape.Meta.CutsceneMap {
		Name = "DeadPrincess",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Map "Ship_IsabelleIsland_Pirate"
	}

	ItsyScape.Meta.CutsceneMap {
		Name = "SoakedLog",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Map "Ship_IsabelleIsland_PortmasterJenkins"
	}

	ItsyScape.Meta.CutscenePeep {
		Name = "CapnRaven",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_PirateCaptain"
	}

	ItsyScape.Meta.CutscenePeep {
		Name = "Jenkins",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins"
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "IsabelleIsland_FarOcean2_CthulhuRises"

	ItsyScape.Meta.CutsceneMap {
		Name = "DeadPrincess",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Map "Ship_IsabelleIsland_Pirate"
	}

	ItsyScape.Meta.CutsceneMap {
		Name = "SoakedLog",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Map "Ship_IsabelleIsland_PortmasterJenkins"
	}

	ItsyScape.Meta.CutscenePeep {
		Name = "CapnRaven",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_PirateCaptain"
	}

	ItsyScape.Meta.CutscenePeep {
		Name = "Jenkins",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins"
	}

	ItsyScape.Meta.CutscenePeep {
		Name = "Rosalind",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Rosalind"
	}

	ItsyScape.Meta.CutscenePeep {
		Name = "Orlando",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Orlando"
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "CameraDolly",
		Cutscene = Cutscene,
		Resource = M["CameraDolly"]
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "IsabelleIsland_FarOcean2_SurvivedSquids"

	ItsyScape.Meta.CutsceneMap {
		Name = "DeadPrincess",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Map "Ship_IsabelleIsland_Pirate"
	}

	ItsyScape.Meta.CutsceneMap {
		Name = "SoakedLog",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Map "Ship_IsabelleIsland_PortmasterJenkins"
	}

	ItsyScape.Meta.CutscenePeep {
		Name = "Jenkins",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins"
	}

	ItsyScape.Meta.CutscenePeep {
		Name = "CapnRaven",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_PirateCaptain"
	}

	ItsyScape.Meta.CutscenePeep {
		Name = "Rosalind",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Rosalind"
	}

	ItsyScape.Meta.CutscenePeep {
		Name = "Orlando",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Orlando"
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Cthulhu",
		Cutscene = Cutscene,
		Resource = M["Cthulhu"]
	}
end
