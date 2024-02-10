local M = include "Resources/Game/Maps/Intro_Realm/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Intro_Realm.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Realm Intro",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "A preview of the Realm.",
	Language = "en-US",
	Resource = M._MAP
}

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
		PositionX = 1,
		PositionY = 0,
		PositionZ = 1,
		Name = "CameraDolly",
		Map = M._MAP,
		Resource = M["CameraDolly"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CameraDolly",
		MapObject = M["CameraDolly"]
	}
end

M["Anchor_SpawnMap_Center"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Anchor_SpawnMap_Center",
		Map = M._MAP,
		Resource = M["Anchor_SpawnMap_Center"]
	}
end

M["Anchor_Pan1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 16,
		PositionY = 0,
		PositionZ = 48,
		Name = "Anchor_Pan1",
		Map = M._MAP,
		Resource = M["Anchor_Pan1"]
	}
end

M["Anchor_Pan2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 48,
		PositionY = 0,
		PositionZ = 16,
		Name = "Anchor_Pan2",
		Map = M._MAP,
		Resource = M["Anchor_Pan2"]
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "Intro_Realm"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "CameraDolly",
		Cutscene = Cutscene,
		Resource = M["CameraDolly"]
	}
end
