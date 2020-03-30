local M = include "Resources/Game/Maps/MapTable_Main/DB/Default.lua"

ItsyScape.Meta.ResourceName {
	Value = "Map Table",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "The map of the known Realm.",
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
		ColorRed = 207,
		ColorGreen = 165,
		ColorBlue = 68,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.8,
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
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 3,
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
		ColorRed = 126,
		ColorGreen = 73,
		ColorBlue = 33,
		NearDistance = 25,
		FarDistance = 100,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_ChartTown_Rumbridge"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 81,
		PositionY = 5,
		PositionZ = 79,
		Name = "Anchor_ChartTown_Rumbridge",
		Map = M._MAP,
		Resource = M["Anchor_ChartTown_Rumbridge"]
	}
end

M["Anchor_ChartTown_ViziersRock"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 81,
		PositionY = 7,
		PositionZ = 59,
		Name = "Anchor_ChartTown_ViziersRock",
		Map = M._MAP,
		Resource = M["Anchor_ChartTown_ViziersRock"]
	}
end

M["Anchor_ChartTown_WhiteCastleUponTheRock"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 67,
		PositionY = 5,
		PositionZ = 63,
		Name = "Anchor_ChartTown_WhiteCastleUponTheRock",
		Map = M._MAP,
		Resource = M["Anchor_ChartTown_WhiteCastleUponTheRock"]
	}
end

M["Anchor_ChartTown_EmptyRuins"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 71,
		PositionY = 5,
		PositionZ = 45,
		Name = "Anchor_ChartTown_EmptyRuins",
		Map = M._MAP,
		Resource = M["Anchor_ChartTown_EmptyRuins"]
	}
end

M["Anchor_ChartTown_IsabelleIsland"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 55,
		PositionY = 6,
		PositionZ = 95,
		Name = "Anchor_ChartTown_IsabelleIsland",
		Map = M._MAP,
		Resource = M["Anchor_ChartTown_IsabelleIsland"]
	}
end

M["Anchor_ChartX_MermanStronghold"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 91,
		PositionY = 6,
		PositionZ = 95,
		Name = "Anchor_ChartX_MermanStronghold",
		Map = M._MAP,
		Resource = M["Anchor_ChartX_MermanStronghold"]
	}
end

M["Anchor_ChartX_RuinsOfRhysylk"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 79,
		PositionY = 5,
		PositionZ = 91,
		Name = "Anchor_ChartX_RuinsOfRhysylk",
		Map = M._MAP,
		Resource = M["Anchor_ChartX_RuinsOfRhysylk"]
	}
end

M["Anchor_ChartX_MheesasIsland"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 73,
		PositionY = 5,
		PositionZ = 105,
		Name = "Anchor_ChartX_MheesasIsland",
		Map = M._MAP,
		Resource = M["Anchor_ChartX_MheesasIsland"]
	}
end

M["Anchor_ChartX_BlackmeltLagoon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 95,
		PositionY = 5,
		PositionZ = 111,
		Name = "Anchor_ChartX_BlackmeltLagoon",
		Map = M._MAP,
		Resource = M["Anchor_ChartX_BlackmeltLagoon"]
	}
end

return M
