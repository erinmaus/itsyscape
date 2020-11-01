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
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_SecretCorner"] {
		TravelAction
	}
end
