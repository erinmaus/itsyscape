local M = include "Resources/Game/Maps/Purgatory/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Purgatory.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Purgatory",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "The place between life and death...",
	Language = "en-US",
	Resource = M._MAP
}

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 1,
		PositionY = 0,
		PositionZ = 1,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end
