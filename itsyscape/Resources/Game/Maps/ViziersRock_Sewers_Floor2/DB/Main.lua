local M = include "Resources/Game/Maps/ViziersRock_Sewers_Floor2/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.ViziersRock_Sewers_Floor2.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Vizier's Rock Sewers, Floor 2",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Arachnids!",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.RaidGroup {
	Raid = ItsyScape.Resource.Raid "ViziersRockSewers",
	Map = M._MAP
}

M["Light_Ambient"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Ambient",
		Map = M._MAP,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "AmbientLight_Default",
		MapObject = M["Light_Ambient"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 120,
		ColorGreen = 91,
		ColorBlue = 70,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.2,
		Resource = M["Light_Ambient"]
	}
end

M["Light_Sun"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Sun",
		Map = M._MAP,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "DirectionalLight_Default",
		MapObject = M["Light_Sun"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 120,
		ColorGreen = 91,
		ColorBlue = 70,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 5,
		DirectionZ = 4,
		Resource = M["Light_Sun"]
	}
end

M["Light_Fog"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Fog",
		Map = M._MAP,
		Resource = M["Light_Fog"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Fog_Default",
		MapObject = M["Light_Fog"]
	}

	ItsyScape.Meta.Fog {
		ColorRed = 89,
		ColorGreen = 120,
		ColorBlue = 89,
		NearDistance = 15,
		FarDistance = 25,
		FollowTarget = 1,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_FromFloor1Puzzle"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 0,
		PositionZ = 19,
		Name = "Anchor_FromFloor1Puzzle",
		Map = M._MAP,
		Resource = M["Anchor_FromFloor1Puzzle"]
	}
end

M["Ladder_ToPuzzle_Floor1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 0,
		PositionZ = 19,
		Name = "Ladder_ToPuzzle_Floor1",
		Map = M._MAP,
		Resource = M["Ladder_ToPuzzle_Floor1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "MetalLadder_Default",
		MapObject = M["Ladder_ToPuzzle_Floor1"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_ToPuzzleTrapDoor_Floor1",
		Map = ItsyScape.Resource.Map "ViziersRock_Sewers_Floor1",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_ToPuzzle_Floor1"] {
		TravelAction
	}
end

M["Light_ToKaradon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 17,
		PositionY = 0,
		PositionZ = 19,
		Name = "Light_ToKaradon",
		Map = M._MAP,
		Resource = M["Light_ToKaradon"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_ToKaradon"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Light_ToKaradon"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 16,
		Resource = M["Light_ToKaradon"]
	}
end

M["Light_FromFloor1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 57,
		PositionY = 2,
		PositionZ = 19,
		Name = "Light_FromFloor1",
		Map = M._MAP,
		Resource = M["Light_FromFloor1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_FromFloor1"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Light_FromFloor1"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 16,
		Resource = M["Light_FromFloor1"]
	}
end

M["Light_Matriarch"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 53,
		PositionY = 3,
		PositionZ = 69,
		Name = "Light_Matriarch",
		Map = M._MAP,
		Resource = M["Light_Matriarch"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_Matriarch"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 200,
		ColorGreen = 200,
		ColorBlue = 200,
		Resource = M["Light_Matriarch"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 24,
		Resource = M["Light_Matriarch"]
	}
end

M["Anchor_FromFloor1Puzzle_Other"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 0,
		PositionZ = 19,
		Name = "Anchor_FromFloor1Puzzle_Other",
		Map = M._MAP,
		Resource = M["Anchor_FromFloor1Puzzle_Other"]
	}
end

M["Ladder_ToOtherPuzzle_Floor1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 0,
		PositionZ = 19,
		Name = "Ladder_ToOtherPuzzle_Floor1",
		Map = M._MAP,
		Resource = M["Ladder_ToOtherPuzzle_Floor1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "MetalLadder_Default",
		MapObject = M["Ladder_ToOtherPuzzle_Floor1"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_ToOtherPuzzleTrapDoor_Floor1",
		Map = ItsyScape.Resource.Map "ViziersRock_Sewers_Floor1",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_ToOtherPuzzle_Floor1"] {
		TravelAction
	}
end

M["SewerSpiderMatriarch"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 53,
		PositionY = 0,
		PositionZ = 69,
		Name = "SewerSpiderMatriarch",
		Map = M._MAP,
		Resource = M["SewerSpiderMatriarch"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "SewerSpiderMatriarch",
		MapObject = M["SewerSpiderMatriarch"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}
end

M["Anchor_FromKaradon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19,
		PositionY = 0,
		PositionZ = 19,
		Name = "Anchor_FromKaradon",
		Map = M._MAP,
		Resource = M["Anchor_FromKaradon"]
	}
end

M["Ladder_ToKaradon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 17,
		PositionY = -2,
		PositionZ = 19,
		Name = "Ladder_ToKaradon",
		Map = M._MAP,
		Resource = M["Ladder_ToKaradon"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "MetalLadder_Default",
		MapObject = M["Ladder_ToKaradon"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromFloor2",
		Map = ItsyScape.Resource.Map "ViziersRock_Sewers_Floor3",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		XProgressive = "Climbing-down",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_ToKaradon"] {
		TravelAction
	}
end

M["Valve_SquareTriangle"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 57,
		PositionY = 0.125,
		PositionZ = 19,
		ScaleX = 0.5,
		ScaleY = 0.5,
		ScaleZ = 0.5,
		Name = "Valve_SquareTriangle",
		Map = M._MAP,
		Resource = M["Valve_SquareTriangle"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ViziersRock_Sewers_Valve",
		MapObject = M["Valve_SquareTriangle"]
	}
end

M["Valve_Star"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 57,
		PositionY = 0.125,
		PositionZ = 39,
		ScaleX = 0.5,
		ScaleY = 0.5,
		ScaleZ = 0.5,
		Name = "Valve_Star",
		Map = M._MAP,
		Resource = M["Valve_Star"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ViziersRock_Sewers_Valve",
		MapObject = M["Valve_Star"]
	}
end

M["Valve_Circle"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 51,
		PositionY = 1.125,
		PositionZ = 55,
		ScaleX = 0.5,
		ScaleY = 0.5,
		ScaleZ = 0.5,
		Name = "Valve_Circle",
		Map = M._MAP,
		Resource = M["Valve_Circle"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ViziersRock_Sewers_Valve",
		MapObject = M["Valve_Circle"]
	}
end

M["Door_Circle1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 0,
		PositionZ = 29,
		Name = "Door_Circle1",
		Map = M._MAP,
		Resource = M["Door_Circle1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ViziersRock_Sewers_WaterDoor",
		MapObject = M["Door_Circle1"]
	}
end

M["Door_Circle2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 67,
		PositionY = 0,
		PositionZ = 19,
		Name = "Door_Circle2",
		Map = M._MAP,
		Resource = M["Door_Circle2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ViziersRock_Sewers_WaterDoor",
		MapObject = M["Door_Circle2"]
	}
end

M["Door_Star1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 67,
		PositionY = 0,
		PositionZ = 39,
		Name = "Door_Star1",
		Map = M._MAP,
		Resource = M["Door_Star1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ViziersRock_Sewers_WaterDoor",
		MapObject = M["Door_Star1"]
	}
end

M["Door_Star2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 77,
		PositionY = 0,
		PositionZ = 29,
		Name = "Door_Star2",
		Map = M._MAP,
		Resource = M["Door_Star2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ViziersRock_Sewers_WaterDoor",
		MapObject = M["Door_Star2"]
	}
end

M["Door_Square1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 57,
		PositionY = 0,
		PositionZ = 29,
		Name = "Door_Square1",
		Map = M._MAP,
		Resource = M["Door_Square1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ViziersRock_Sewers_WaterDoor",
		MapObject = M["Door_Square1"]
	}
end

M["Spider1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 53,
		PositionY = 0,
		PositionZ = 15,
		Name = "Spider1",
		Map = M._MAP,
		Resource = M["Spider1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "SewerSpider",
		MapObject = M["Spider1"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Spider1",
		Map = M._MAP,
		MapObject = M["Spider1"]
	}
end

M["Spider2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 61,
		PositionY = 0,
		PositionZ = 21,
		Name = "Spider2",
		Map = M._MAP,
		Resource = M["Spider2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "SewerSpider",
		MapObject = M["Spider2"],
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Spider2",
		Map = M._MAP,
		MapObject = M["Spider2"]
	}
end

M["Spider3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 87,
		PositionY = 0.5,
		PositionZ = 55,
		Name = "Spider3",
		Map = M._MAP,
		Resource = M["Spider3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "SewerSpider",
		MapObject = M["Spider3"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Spider3",
		Map = M._MAP,
		MapObject = M["Spider3"]
	}
end

M["Spider4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 81,
		PositionY = 2,
		PositionZ = 73,
		Name = "Spider4",
		Map = M._MAP,
		Resource = M["Spider4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "SewerSpider",
		MapObject = M["Spider4"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Spider4",
		Map = M._MAP,
		MapObject = M["Spider4"]
	}
end

M["TrashHeap1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 77,
		PositionY = 0,
		PositionZ = 19,
		Name = "TrashHeap1",
		Map = M._MAP,
		Resource = M["TrashHeap1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "TrashHeap",
		MapObject = M["TrashHeap1"]
	}
end

M["TrashHeap2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 0,
		PositionZ = 39,
		Name = "TrashHeap2",
		Map = M._MAP,
		Resource = M["TrashHeap2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "TrashHeap",
		MapObject = M["TrashHeap2"]
	}
end

M["Rat1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 75,
		PositionY = 0,
		PositionZ = 35,
		Name = "Rat1",
		Map = M._MAP,
		Resource = M["Rat1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Rat",
		MapObject = M["Rat1"]
	}
end

M["Rat2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 79,
		PositionY = 0,
		PositionZ = 39,
		Name = "Rat2",
		Map = M._MAP,
		Resource = M["Rat2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Rat",
		MapObject = M["Rat2"]
	}
end
