local M = include "Resources/Game/Maps/IsabelleIsland_Tower3/DB/Default.lua"

ItsyScape.Meta.ResourceName {
	Value = "Isabelle Island, Tower",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Once known as the crooked tower.",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.IsabelleIsland_Tower3.Peep",
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
		ColorGreen = 173,
		ColorBlue = 119,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.3,
		Resource = M["Light_Ambient"]
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
		ColorRed = 0,
		ColorGreen = 0,
		ColorBlue = 0,
		NearDistance = 150,
		FarDistance = 200,
		Resource = M["Light_Fog"]
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
		ColorRed = 130,
		ColorGreen = 130,
		ColorBlue = 130,
		CastsShadows = 1,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 8,
		DirectionZ = -4,
		Resource = M["Light_Sun"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 50,
		PositionY = 0,
		PositionZ = 50,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Anchor_Floor2Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 0,
		PositionZ = 15,
		Layer = 4,
		Name = "Anchor_Floor2Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Floor2Spawn"]
	}
end

M["IsabelleIslandTowerLargeDoor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 59,
		PositionY = 12,
		PositionZ = 81,
		Name = "IsabelleIslandTowerLargeDoor",
		Map = M._MAP,
		Resource = M["IsabelleIslandTowerLargeDoor"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "IsabelleIslandTowerLargeDoor",
		MapObject = M["IsabelleIslandTowerLargeDoor"]
	}

	M["IsabelleIslandTowerLargeDoor"] {
		ItsyScape.Action.Open(),
		ItsyScape.Action.Close()
	}
end

M["GildedDragon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 59,
		PositionY = 12,
		PositionZ = 59,
		Name = "GildedDragon",
		Map = M._MAP,
		Resource = M["GildedDragon"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "GildedDragon",
		MapObject = M["GildedDragon"]
	}
end

M["Plinth_GildedDragon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 59,
		PositionY = 12,
		PositionZ = 69,
		Name = "Plinth_GildedDragon",
		Map = M._MAP,
		Resource = M["Plinth_GildedDragon"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Plinth_Isabelle",
		MapObject = M["Plinth_GildedDragon"]
	}

	local Read = ItsyScape.Action.Read_Plinth()

	ItsyScape.Meta.PlinthExhibit {
		ExhibitResource = M["GildedDragon"],
		ExhibitName = "Gilded royal dragon",
		ExhibitDescription = "One of the last known royal dragons, slain by Isabelle. Isabelle personally smelted gold with the bones to gild them.",
		Zoom = 3,
		OffsetY = 0.5,
		Language = "en-US",
		Action = Read
	}

	M["Plinth_GildedDragon"] {
		Read
	}
end
