local M = include "Resources/Game/Maps/Rumbridge_Castle/DB/Default.lua"

-- ItsyScape.Meta.PeepID {
-- 	Value = "Resources.Game.Maps.Rumbridge_Castle.Peep",
-- 	Resource = M._MAP
-- }

ItsyScape.Meta.ResourceName {
	Value = "Rumbridge, Castle",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Castle of Earl Reddick and home of the Rumbridge.",
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
		ColorRed = 231,
		ColorGreen = 168,
		ColorBlue = 194,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.6,
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
		ColorRed = 175,
		ColorGreen = 223,
		ColorBlue = 233,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 3,
		DirectionZ = 4,
		Resource = M["Light_Sun"]
	}
end

M["Anchor_FromFloor1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 4,
		PositionZ = 15,
		Name = "Anchor_FromFloor1",
		Map = M._MAP,
		Resource = M["Anchor_FromFloor1"]
	}
end

M["Anchor_FromBasement"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 4,
		PositionZ = 29,
		Name = "Anchor_FromBasement",
		Map = M._MAP,
		Resource = M["Anchor_FromBasement"]
	}
end

M["Anchor_FromDungeon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
		PositionY = 4,
		PositionZ = 39,
		Name = "Anchor_FromDungeon",
		Map = M._MAP,
		Resource = M["Anchor_FromDungeon"]
	}
end

M["SpiralStaircase"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 4,
		PositionZ = 13,
		Name = "SpiralStaircase",
		Map = M._MAP,
		Resource = M["SpiralStaircase"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "SpiralStaircase_Default",
		MapObject = M["SpiralStaircase"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromStairs",
		Map = ItsyScape.Resource.Map "Rumbridge_Castle_Floor1",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["SpiralStaircase"] {
		TravelAction
	}
end
