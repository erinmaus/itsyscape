local M = include "Resources/Game/Maps/Test123_Draft/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Test123_Draft.Peep",
	Resource = M._MAP
}

M["DebrisRing"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 64,
		PositionY = 0,
		PositionZ = 64,
		Name = "DebrisRing",
		Map = M._MAP,
		Resource = M["DebrisRing"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "MoonDebrisRing_Default",
		MapObject = M["DebrisRing"]
	}
end

M["Stars"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 64,
		PositionY = 0,
		PositionZ = 64,
		Name = "Stars",
		Map = M._MAP,
		Resource = M["Stars"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Stars_Default",
		MapObject = M["Stars"]
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
