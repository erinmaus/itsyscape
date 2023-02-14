local M = include "Resources/Game/Maps/Trailer_RhlorOcean/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Trailer_RhlorOcean.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Trailer, Rh'lor Ocean",
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
		ColorRed = 33,
		ColorGreen = 33,
		ColorBlue = 33,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.3,
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

M["Light_Fog"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Fog",
		Map = M._MAP,
		Resource = M["Light_Fog"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Fog_Default",
		MapObject = M["Light_Fog"]
	}

	ItsyScape.Meta.Fog {
		ColorRed = 33,
		ColorGreen = 33,
		ColorBlue = 33,
		NearDistance = 30,
		FarDistance = 60,
		FollowTarget = 1,
		Resource = M["Light_Fog"]
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
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Cthulhu",
		MapObject = M["Cthulhu"]
	}
end

M["Cthulhu_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = -8,
		PositionZ = 33,
		Name = "Cthulhu_Spawn",
		Map = M._MAP,
		Resource = M["Cthulhu_Spawn"]
	}
end

M["Cthulhu_Lightning1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 40,
		PositionY = 0,
		PositionZ = 42,
		Name = "Cthulhu_Lightning1",
		Map = M._MAP,
		Resource = M["Cthulhu_Lightning1"]
	}
end

M["Cthulhu_Lightning2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 0,
		PositionZ = 33,
		Name = "Cthulhu_Lightning2",
		Map = M._MAP,
		Resource = M["Cthulhu_Lightning2"]
	}
end

M["Anchor_Spawn"]= ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = -64,
		PositionY = 0,
		PositionZ = -64,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Anchor_Cthulhu_Spawn1"]= ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 0,
		PositionZ = 33,
		Name = "Anchor_Cthulhu_Spawn1",
		Map = M._MAP,
		Resource = M["Anchor_Cthulhu_Spawn1"]
	}
end

M["Anchor_Cthulhu_Spawn2"]= ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 16,
		PositionZ = 33,
		Name = "Anchor_Cthulhu_Spawn2",
		Map = M._MAP,
		Resource = M["Anchor_Cthulhu_Spawn2"]
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

M["Anchor_PlayerShip_1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 48,
		PositionY = 0,
		PositionZ = 64,
		Map = M._MAP,
		Name = "Anchor_PlayerShip_1",
		Resource = M["Anchor_PlayerShip_1"]
	}
end

M["Anchor_PlayerShip_2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 64,
		Map = M._MAP,
		Name = "Anchor_PlayerShip_2",
		Resource = M["Anchor_PlayerShip_2"]
	}
end

M["Anchor_PlayerShip_3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Map = M._MAP,
		Name = "Anchor_PlayerShip_3",
		Resource = M["Anchor_PlayerShip_3"]
	}
end

M["Anchor_PirateShip_1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 64 + 32,
		PositionY = 0,
		PositionZ = 64 + 32,
		Map = M._MAP,
		Name = "Anchor_PirateShip_1",
		Resource = M["Anchor_PirateShip_1"]
	}
end

M["Anchor_PirateShip_2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0 + 64 + 16,
		PositionY = 0,
		PositionZ = -48,
		Map = M._MAP,
		Name = "Anchor_PirateShip_2",
		Resource = M["Anchor_PirateShip_2"]
	}
end

M["Anchor_PirateShip_3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = -16,
		PositionY = 0,
		PositionZ = 0 + 64,
		Map = M._MAP,
		Name = "Anchor_PirateShip_3",
		Resource = M["Anchor_PirateShip_3"]
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "Trailer_RhlorOcean_Cthulhu"

	ItsyScape.Meta.CutscenePeep {
		Name = "CapnRaven",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_PirateCaptain"
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "CameraDolly",
		Cutscene = Cutscene,
		Resource = M["CameraDolly"]
	}

	ItsyScape.Meta.CutscenePeep {
		Name = "Jenkins",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins"
	}

	ItsyScape.Meta.CutsceneMap {
		Name = "PirateShip",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Map "Ship_IsabelleIsland_Pirate"
	}

	ItsyScape.Meta.CutsceneMap {
		Name = "PlayerShip",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Map "Ship_IsabelleIsland_PortmasterJenkins"
	}
end
