local M = include "Resources/Game/Maps/GoredDragon/DB/Default.lua"

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
		ColorRed = 160,
		ColorGreen = 44,
		ColorBlue = 75,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.4,
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
		ColorRed = 160,
		ColorGreen = 44,
		ColorBlue = 75,
		NearDistance = 35,
		FarDistance = 50,
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
		ColorRed = 239,
		ColorGreen = 230,
		ColorBlue = 205,
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

M["GroundFog"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "GroundFog",
		Map = M._MAP,
		Resource = M["GroundFog"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "GroundFog",
		MapObject = M["GroundFog"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 149,
		ColorGreen = 80,
		ColorBlue = 99,
		Resource = M["GroundFog"]
	}
end

M["GoredDragonIntestines"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = -4,
		PositionZ = 13,
		ScaleX = 6,
		ScaleY = 6,
		ScaleZ = 6,
		Name = "GoredDragonIntestines",
		Map = M._MAP,
		Resource = M["GoredDragonIntestines"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "GoredDragonIntestines",
		MapObject = M["GoredDragonIntestines"]
	}
end

M["GoredDragonFlameSac"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = -8,
		PositionZ = 57,
		ScaleX = 3,
		ScaleY = 3,
		ScaleZ = 3,
		Name = "GoredDragonFlameSac",
		Map = M._MAP,
		Resource = M["GoredDragonFlameSac"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "GoredDragonFlameSac",
		MapObject = M["GoredDragonFlameSac"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = -4,
		PositionZ = 15,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end
