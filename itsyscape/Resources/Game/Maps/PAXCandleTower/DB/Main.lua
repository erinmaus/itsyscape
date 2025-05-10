local M = include "Resources/Game/Maps/PAXCandleTower/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.PAXCandleTower.Peep",
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
		ColorRed = 231,
		ColorGreen = 168,
		ColorBlue = 194,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 1,
		Resource = M["Light_Ambient"]
	}
end

M["FireLeft"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 17,
		PositionY = 1,
		PositionZ = 50,
		ScaleX = 10,
		ScaleY = 10,
		ScaleZ = 10,
		Name = "FireLeft",
		Map = M._MAP,
		Resource = M["FireLeft"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Art_Rage_Fire",
		MapObject = M["FireLeft"]
	}
end

M["FireRight"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47,
		PositionY = 1,
		PositionZ = 17,
		ScaleX = 10,
		ScaleY = 10,
		ScaleZ = 10,
		Name = "FireRight",
		Map = M._MAP,
		Resource = M["FireRight"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Art_Rage_Fire",
		MapObject = M["FireRight"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 1,
		PositionZ = 33,
		Direction = -1,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Anchor_Left"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 63,
		PositionY = 1,
		PositionZ = 1,
		Direction = -1,
		Name = "Anchor_Left",
		Map = M._MAP,
		Resource = M["Anchor_Left"]
	}
end

M["Anchor_Right"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 1,
		PositionY = 1,
		PositionZ = 63,
		Direction = -1,
		Name = "Anchor_Right",
		Map = M._MAP,
		Resource = M["Anchor_Right"]
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
		MapObject = M["CameraDolly"],
	}
end

M["Yendorian"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 63,
		PositionY = 5,
		PositionZ = 63,
		Name = "Yendorian",
		Map = M._MAP,
		Resource = M["Yendorian"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendorian_Ballista",
		MapObject = M["Yendorian"],
	}
end

M["Tinkerer"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 63,
		PositionY = 5,
		PositionZ = 63,
		Name = "Tinkerer",
		Map = M._MAP,
		Resource = M["Tinkerer"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Tinkerer",
		MapObject = M["Tinkerer"],
	}
end

M["ChestMimic"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 63,
		PositionY = 5,
		PositionZ = 63,
		Name = "ChestMimic",
		Map = M._MAP,
		Resource = M["ChestMimic"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "ChestMimic",
		MapObject = M["ChestMimic"],
	}
end

M["Svalbard"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 63,
		PositionY = 5,
		PositionZ = 63,
		ScaleX = 1,
		ScaleY = 1,
		ScaleZ = 1,
		Name = "Svalbard",
		Map = M._MAP,
		Resource = M["Svalbard"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Svalbard",
		MapObject = M["Svalbard"],
	}
end

M["RatKing"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 63,
		PositionY = 5,
		PositionZ = 63,
		Name = "RatKing",
		Map = M._MAP,
		Resource = M["RatKing"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "RatKingUnleashed",
		MapObject = M["RatKing"],
	}
end

M["Cthulhu"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 63,
		PositionY = 5,
		PositionZ = 63,
		ScaleX = 0.25,
		ScaleY = 0.25,
		ScaleZ = 0.25,
		Name = "Cthulhu",
		Map = M._MAP,
		Resource = M["Cthulhu"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Cthulhu",
		MapObject = M["Cthulhu"],
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "PAXCandleTower_Cutscene"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "CameraDolly",
		Cutscene = Cutscene,
		Resource = M["CameraDolly"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Cthulhu",
		Cutscene = Cutscene,
		Resource = M["Cthulhu"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Yendorian",
		Cutscene = Cutscene,
		Resource = M["Yendorian"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Tinkerer",
		Cutscene = Cutscene,
		Resource = M["Tinkerer"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "ChestMimic",
		Cutscene = Cutscene,
		Resource = M["ChestMimic"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Svalbard",
		Cutscene = Cutscene,
		Resource = M["Svalbard"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "RatKing",
		Cutscene = Cutscene,
		Resource = M["RatKing"]
	}
end
