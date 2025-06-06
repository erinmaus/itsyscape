local M = include "Resources/Game/Maps/Rumbridge_LeafyLake/DB/Default.lua"

ItsyScape.Meta.ResourceName {
	Value = "Rumbridge, Leafy Lake",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Home of the infamous freshwater squidshark.",
	Language = "en-US",
	Resource = M._MAP
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
		ColorRed = 168,
		ColorGreen = 231,
		ColorBlue = 194,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.8,
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
		ColorRed = 162,
		ColorGreen = 234,
		ColorBlue = 33,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = -4,
		DirectionY = 10,
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
		ColorRed = 81,
		ColorGreen = 117,
		ColorBlue = 16,
		NearDistance = 60,
		FarDistance = 120,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_FromCity"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 3,
		PositionY = 4,
		PositionZ = 47,
		Name = "Anchor_FromCity",
		Map = M._MAP,
		Resource = M["Anchor_FromCity"]
	}
end

M["Portal_ToCity"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 3,
		PositionY = 4,
		PositionZ = 49,
		Name = "Portal_ToCity",
		Map = M._MAP,
		Resource = M["Portal_ToCity"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 6,
		SizeY = 2,
		SizeZ = 6,
		MapObject = M["Portal_ToCity"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_ToCity"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rumbridge City, East",
		Language = "en-US",
		Resource = M["Portal_ToCity"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromLeafyLake",
		Map = ItsyScape.Resource.Map "Rumbridge_Town_Homes",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Enter",
		XProgressive = "Entering",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_ToCity"] {
		TravelAction
	}
end

M["Anchor_FromFarm"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 26,
		PositionY = 5,
		PositionZ = 5,
		Name = "Anchor_FromFarm",
		Map = M._MAP,
		Resource = M["Anchor_FromFarm"]
	}
end

M["Portal_ToFarm"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 26,
		PositionY = 5,
		PositionZ = 3,
		Name = "Portal_ToFarm",
		Map = M._MAP,
		Resource = M["Portal_ToFarm"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 6,
		SizeY = 2,
		SizeZ = 6,
		MapObject = M["Portal_ToFarm"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_ToFarm"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rumbridge Farm, East",
		Language = "en-US",
		Resource = M["Portal_ToFarm"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromLeafyLake",
		Map = ItsyScape.Resource.Map "Rumbridge_Farm2",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Enter",
		XProgressive = "Entering",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_ToFarm"] {
		TravelAction
	}
end

M["Cheep"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 26,
		PositionY = 5.5,
		PositionZ = 7,
		Name = "Cheep",
		Map = M._MAP,
		Resource = M["Cheep"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Cheep_Base",
		MapObject = M["Cheep"]
	}
end

M["Dandy1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 5,
		PositionZ = 13,
		Name = "Dandy1",
		Map = M._MAP,
		Resource = M["Dandy1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Dandy",
		MapObject = M["Dandy1"]
	}
end

M["Dandy2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 17,
		PositionY = 5,
		PositionZ = 15,
		Name = "Dandy2",
		Map = M._MAP,
		Resource = M["Dandy2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Dandy",
		MapObject = M["Dandy2"]
	}
end

M["Dandy3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 5,
		PositionY = 4,
		PositionZ = 65,
		Name = "Dandy3",
		Map = M._MAP,
		Resource = M["Dandy3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Dandy",
		MapObject = M["Dandy3"]
	}
end

M["DeadDandy1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41,
		PositionY = 4.5,
		PositionZ = 53,
		Name = "DeadDandy1",
		Map = M._MAP,
		Resource = M["DeadDandy1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "DeadDandy",
		MapObject = M["DeadDandy1"]
	}
end

M["DeadDandy2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 75,
		PositionY = 6,
		PositionZ = 15,
		Name = "DeadDandy2",
		Map = M._MAP,
		Resource = M["DeadDandy2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "DeadDandy",
		MapObject = M["DeadDandy2"]
	}
end

M["DeadDandy3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 85,
		PositionY = 5,
		PositionZ = 43,
		Name = "DeadDandy3",
		Map = M._MAP,
		Resource = M["DeadDandy3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "DeadDandy",
		MapObject = M["DeadDandy3"]
	}
end

M["Anchor_IslandFromCavern"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41,
		PositionY = 5,
		PositionZ = 51,
		Name = "Anchor_IslandFromCavern",
		Map = M._MAP,
		Resource = M["Anchor_IslandFromCavern"]
	}
end

M["Ladder_Island"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41,
		PositionY = 3,
		PositionZ = 49,
		Name = "Ladder_Island",
		Map = M._MAP,
		Resource = M["Ladder_Island"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["Ladder_Island"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_IslandLadder",
		Map = ItsyScape.Resource.Map "Rumbridge_LeafyLake_Cavern",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		XProgressive = "Climbing-down",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_Island"] {
		TravelAction
	}
end

M["Anchor_FromCavernSW"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7,
		PositionY = 5,
		PositionZ = 87,
		Name = "Anchor_FromCavernSW",
		Map = M._MAP,
		Resource = M["Anchor_FromCavernSW"]
	}
end

M["Ladder_CavernEntrance"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 9,
		PositionY = 2,
		PositionZ = 87,
		Name = "Ladder_CavernEntrance",
		Map = M._MAP,
		Resource = M["Ladder_CavernEntrance"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["Ladder_CavernEntrance"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_SWLadder",
		Map = ItsyScape.Resource.Map "Rumbridge_LeafyLake_Cavern",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		XProgressive = "Climbing-down",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_CavernEntrance"] {
		TravelAction
	}
end

M["Anchor_FromCavernSE"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 91,
		PositionY = 6,
		PositionZ = 73,
		Name = "Anchor_FromCavernSE",
		Map = M._MAP,
		Resource = M["Anchor_FromCavernSE"]
	}
end

M["Ladder_SecretCorner"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 89,
		PositionY = 3,
		PositionZ = 73,
		Name = "Ladder_SecretCorner",
		Map = M._MAP,
		Resource = M["Ladder_SecretCorner"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["Ladder_SecretCorner"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_SELadder",
		Map = ItsyScape.Resource.Map "Rumbridge_LeafyLake_Cavern",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		XProgressive = "Climbing-down",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_SecretCorner"] {
		TravelAction
	}
end

M["BankChest"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 83,
		PositionY = 5,
		PositionZ = 47,
		RotationX = 0,
		RotationY = 1,
		RotationZ = 0,
		RotationW = 0,
		Name = "BankChest",
		Map = M._MAP,
		Resource = M["BankChest"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Chest_Default",
		MapObject = M["BankChest"]
	}

	M["BankChest"] {
		ItsyScape.Action.Bank()
	}
end
