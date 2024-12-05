local M = include "Resources/Game/Maps/Test123_Storm/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Test123_Storm.Peep",
	Resource = M._MAP
}

M["SkyLight"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "SkyLight",
		Map = M._MAP,
		Resource = M["SkyLight"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "DirectionalLight_Default",
		MapObject = M["SkyLight"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 45,
		ColorGreen = 45,
		ColorBlue = 85,
		Resource = M["SkyLight"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 0,
		DirectionY = -1,
		DirectionZ = 0,
		Resource = M["SkyLight"]
	}
end

M["Storm"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 64,
		PositionY = 0,
		PositionZ = 64,
		Name = "Storm",
		Map = M._MAP,
		Resource = M["Storm"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Storm_Default",
		MapObject = M["Storm"]
	}
end

M["Sky"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 64,
		PositionY = 0,
		PositionZ = 64,
		Name = "Sky",
		Map = M._MAP,
		Resource = M["Sky"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Sky_Default",
		MapObject = M["Sky"]
	}
end


M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 64,
		PositionY = 1,
		PositionZ = 64,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end
