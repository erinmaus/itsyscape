local M = include "Resources/Game/Maps/Trailer_AncientGlyphforge/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Trailer_AncientGlyphforge.Peep",
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
		NearDistance = 50,
		FarDistance = 100,
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
		PositionX = 33,
		PositionY = 0,
		PositionZ = 33,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Anchor_Peak"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 131,
		PositionY = 16,
		PositionZ = 79,
		Name = "Anchor_Peak",
		Map = M._MAP,
		Resource = M["Anchor_Peak"]
	}
end

M["GoredDragon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 3,
		PositionZ = 33,
		ScaleX = 0.5,
		ScaleY = 0.5,
		ScaleZ = 0.5,
		Name = "GoredDragon",
		Map = M._MAP,
		Resource = M["GoredDragon"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "GoredDragon",
		MapObject = M["GoredDragon"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}
end
