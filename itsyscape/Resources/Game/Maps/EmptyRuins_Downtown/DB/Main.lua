local M = include "Resources/Game/Maps/EmptyRuins_Downtown/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.EmptyRuins_Downtown.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Downtown, Empty Ruins",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Only the strongest of wills resist the temptation of death in this horrible place.",
	Language = "en-US",
	Resource = M._MAP
}

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
		PositionY = 5,
		PositionZ = 9,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end
