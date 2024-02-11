local M = include "Resources/Game/Maps/EmptyRuins_SistineOfTheSimulacrum_Outside/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.EmptyRuins_SistineOfTheSimulacrum_Outside.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Sistine of the Simulacrum Exterior, Empty Ruins",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "The throne of the Divine Bureaucracy and Fate Mashina.",
	Language = "en-US",
	Resource = M._MAP
}

M["Light_SistineDoor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 51,
		PositionY = 8,
		PositionZ = 83,
		Name = "Light_SistineDoor",
		Map = M._MAP,
		Resource = M["Light_SistineDoor"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_SistineDoor"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Light_SistineDoor"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 32,
		Resource = M["Light_SistineDoor"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 1,
		PositionZ = 61,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Yendor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Yendor",
		Map = M._MAP,
		Resource = M["Yendor"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendor",
		MapObject = M["Yendor"]
	}
end

M["Anchor_Yendor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 59,
		PositionY = 1,
		PositionZ = 96,
		Name = "Anchor_Yendor",
		Map = M._MAP,
		Resource = M["Anchor_Yendor"]
	}
end

M["TheEmptyKing"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "TheEmptyKing",
		Map = M._MAP,
		Resource = M["TheEmptyKing"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "TheEmptyKing_FullyRealized_Cutscene",
		MapObject = M["TheEmptyKing"]
	}
end

M["Anchor_TheEmptyKing"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 51,
		PositionY = 1,
		PositionZ = 69,
		Name = "Anchor_TheEmptyKing",
		Map = M._MAP,
		Resource = M["Anchor_TheEmptyKing"]
	}
end

M["Gottskrieg"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Gottskrieg",
		Map = M._MAP,
		Resource = M["Gottskrieg"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "TheEmptyKing_FullyRealized_Staff",
		MapObject = M["Gottskrieg"]
	}
end

M["Anchor_Gottskrieg"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 1,
		PositionZ = 85,
		Name = "Anchor_Gottskrieg",
		Map = M._MAP,
		Resource = M["Anchor_Gottskrieg"]
	}
end

M["CameraDolly"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "CameraDolly",
		Map = M._MAP,
		Resource = M["CameraDolly"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CameraDolly",
		MapObject = M["CameraDolly"]
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "EmptyRuins_SistineOfTheSimulacrum_Outside_Intro"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "TheEmptyKing",
		Cutscene = Cutscene,
		Resource = M["TheEmptyKing"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Gottskrieg",
		Cutscene = Cutscene,
		Resource = M["Gottskrieg"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Yendor",
		Cutscene = Cutscene,
		Resource = M["Yendor"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "CameraDolly",
		Cutscene = Cutscene,
		Resource = M["CameraDolly"]
	}
end
