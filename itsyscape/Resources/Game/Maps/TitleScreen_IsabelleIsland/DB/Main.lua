local M = include "Resources/Game/Maps/TitleScreen_IsabelleIsland/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.TitleScreen_IsabelleIsland.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Title Screen, Isabelle Island",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "A preview of Isabelle Island.",
	Language = "en-US",
	Resource = M._MAP
}

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 28,
		PositionY = 0,
		PositionZ = 28,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end
