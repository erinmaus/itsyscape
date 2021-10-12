local M = include "Resources/Game/Maps/Rumbridge_Castle_Floor1/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Rumbridge_Castle_Floor1.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Rumbridge, Castle, Floor 1",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Sleeping quarters of the Earl and his guests.",
	Language = "en-US",
	Resource = M._MAP
}

M["Anchor_FromStairs"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 0,
		PositionZ = 15,
		Name = "Anchor_FromStairs",
		Map = M._MAP,
		Resource = M["Anchor_FromStairs"]
	}
end

M["Anchor_FromLadder"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 49,
		PositionY = 0,
		PositionZ = 15,
		Name = "Anchor_FromLadder",
		Map = M._MAP,
		Resource = M["Anchor_FromLadder"]
	}
end