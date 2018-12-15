local M = include "Resources/Game/Maps/Ship_Test/DB/Default.lua"

M["Anchor_TestSpawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15.000000,
		PositionY = 4.000000,
		PositionZ = 11.000000,
		RotiationX = 0.000000,
		RotiationY = 0.000000,
		RotiationZ = 0.000000,
		RotiationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Anchor_TestSpawn",
		Map = M._MAP,
		Resource = M["Anchor_TestSpawn"]
	}
end
