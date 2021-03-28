local M = include "Resources/Game/Maps/IsabelleIsland_Tower_Floor5/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.IsabelleIsland_Tower_Floor5.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Isabelle Island, Tower Floor 5",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "The non-descript place where your adventure starts.",
	Language = "en-US",
	Resource = M._MAP
}

M["Anchor_DownStairs"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 17,
		PositionY = 0,
		PositionZ = 35,
		Name = "Anchor_DownStairs",
		Map = M._MAP,
		Resource = M["Anchor_DownStairs"]
	}
end
