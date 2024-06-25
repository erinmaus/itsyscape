local M = include "Resources/Game/Maps/Test123_Draft/DB/Default.lua"

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
		ColorRed = 128,
		ColorGreen = 128,
		ColorBlue = 128,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.5,
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
		ColorRed = 100,
		ColorGreen = 100,
		ColorBlue = 100,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 3,
		DirectionZ = 4,
		Resource = M["Light_Sun"]
	}
end

-- M["Light_Fog"] = ItsyScape.Resource.MapObject.Unique()
-- do
-- 	ItsyScape.Meta.MapObjectLocation {
-- 		PositionX = 0,
-- 		PositionY = 0,
-- 		PositionZ = 0,
-- 		Name = "Light_Fog",
-- 		Map = M._MAP,
-- 		Resource = M["Light_Fog"]
-- 	}

-- 	ItsyScape.Meta.PropMapObject {
-- 		Prop = ItsyScape.Resource.Prop "Fog_Default",
-- 		MapObject = M["Light_Fog"]
-- 	}

-- 	ItsyScape.Meta.Fog {
-- 		ColorRed = 0,
-- 		ColorGreen = 0,
-- 		ColorBlue = 0,
-- 		NearDistance = 32,
-- 		FarDistance = 48,
-- 		Resource = M["Light_Fog"]
-- 	}
-- end

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
