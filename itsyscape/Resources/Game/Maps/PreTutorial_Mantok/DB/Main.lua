local M = include "Resources/Game/Maps/PreTutorial_Mantok/DB/Default.lua"

ItsyScape.Meta.ResourceName {
	Value = "Azathoth",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Man'tok, the First One.",
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

M["Mantok"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 1,
		PositionY = 0,
		PositionZ = 1,
		Name = "Mantok",
		Map = M._MAP,
		Resource = M["Mantok"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Mantok",
		MapObject = M["Mantok"]
	}
end
