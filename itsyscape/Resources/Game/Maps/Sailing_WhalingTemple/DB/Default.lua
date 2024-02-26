local M = {}

M._MAP = ItsyScape.Resource.Map "Sailing_WhalingTemple"

M["TrapDoor_Default2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31.000000,
		PositionY = 5.000000,
		PositionZ = 31.000000,
		RotationX = 0.000000,
		RotationY = 0.000000,
		RotationZ = 0.000000,
		RotationW = 1.000000,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "TrapDoor_Default2",
		Map = M._MAP,
		Resource = M["TrapDoor_Default2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "TrapDoor_Default",
		MapObject = M["TrapDoor_Default2"]
	}
end

return M
