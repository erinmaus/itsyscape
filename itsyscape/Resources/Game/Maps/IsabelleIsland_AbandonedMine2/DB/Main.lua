local M = include "Resources/Game/Maps/IsabelleIsland_AbandonedMine2/DB/Default.lua"

ItsyScape.Meta.ResourceName {
	Value = "Isabelle Island, Abandoned Mine",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "An ancient cavern full of ore... and the restless undead.",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.IsabelleIsland_AbandonedMine2.Peep",
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

M["Anchor_Entrance"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 155,
		PositionY = 6,
		PositionZ = 33,
		Name = "Anchor_Entrance",
		Map = M._MAP,
		Resource = M["Anchor_Entrance"]
	}
end

M["StoneGlyphboundYendorian"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 114,
		PositionY = 9,
		PositionZ = 59,
		Name = "StoneGlyphboundYendorian",
		Map = M._MAP,
		Resource = M["StoneGlyphboundYendorian"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "StoneGlyphboundYendorian",
		MapObject = M["StoneGlyphboundYendorian"]
	}

	ItsyScape.Meta.OldOneDescription {
		Value = "Close your eyes; let the sun set and the shadows grow long." ..
		        "Hear the world grow quieter and feel warmth chill your skin." ..
		        "Silence the mind and in this foolish peace you will know mortal ignorance.",
		Resource = M["StoneGlyphboundYendorian"]
	}
end

M["GlyphstoneRock1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 101,
		PositionY = 9,
		PositionZ = 51,
		Name = "GlyphstoneRock1",
		Map = M._MAP,
		Resource = M["GlyphstoneRock1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "GlyphstoneRock",
		MapObject = M["GlyphstoneRock1"]
	}

	ItsyScape.Meta.OldOneDescription {
		Value = "Close your eyes; let the sun set and the shadows grow long.",
		Resource = M["GlyphstoneRock1"]
	}
end

M["GlyphstoneRock2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 125,
		PositionY = 9,
		PositionZ = 63,
		Name = "GlyphstoneRock2",
		Map = M._MAP,
		Resource = M["GlyphstoneRock2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "GlyphstoneRock",
		MapObject = M["GlyphstoneRock2"]
	}

	ItsyScape.Meta.OldOneDescription {
		Value = "Hear the world grow quieter and feel warmth chill your skin.",
		Resource = M["GlyphstoneRock2"]
	}
end

M["GlyphstoneRock3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 127,
		PositionY = 9,
		PositionZ = 51,
		Name = "GlyphstoneRock3",
		Map = M._MAP,
		Resource = M["GlyphstoneRock3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "GlyphstoneRock",
		MapObject = M["GlyphstoneRock3"]
	}

	ItsyScape.Meta.OldOneDescription {
		Value = "Silence the mind and in this foolish peace you will know mortal ignorance.",
		Resource = M["GlyphstoneRock3"]
	}
end
