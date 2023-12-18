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

M["Behemoth"] = ItsyScape.Resource.MapObject.Unique()
do
	local rotation = ItsyScape.Utility.Quaternion.fromAxisAngle(ItsyScape.Utility.Vector.UNIT_Y, math.pi / 4)

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
		PositionY = 5,
		PositionZ = 32,
		RotationX = rotation.x,
		RotationY = rotation.y,
		RotationZ = rotation.z,
		RotationW = rotation.w,
		Name = "Behemoth",
		Map = M._MAP,
		Resource = M["Behemoth"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Behemoth",
		MapObject = M["Behemoth"]
	}
end
