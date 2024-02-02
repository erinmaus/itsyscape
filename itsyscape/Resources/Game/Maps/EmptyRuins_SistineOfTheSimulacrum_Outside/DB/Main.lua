local M = include "Resources/Game/Maps/EmptyRuins_SistineOfTheSimulacrum_Outside/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.EmptyRuins_SistineOfTheSimulacrum_Outside.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Sistine of the Simulacrum Exterior, Empty Ruins",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "The throne of the Divine Bureaucracy and Fate Mashina.",
	Language = "en-US",
	Resource = M._MAP
}

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 1,
		PositionZ = 61,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end
