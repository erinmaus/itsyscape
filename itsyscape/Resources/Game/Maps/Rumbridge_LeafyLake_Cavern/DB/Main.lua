local M = include "Resources/Game/Maps/Rumbridge_LeafyLake_Cavern/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Rumbridge_LeafyLake_Cavern.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Rumbridge, Leafy Lake Caverns",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Damp.",
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
		ColorRed = 55,
		ColorGreen = 113,
		ColorBlue = 200,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.2,
		Resource = M["Light_Ambient"]
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
		ColorRed = 55,
		ColorGreen = 113,
		ColorBlue = 200,
		NearDistance = 30,
		FarDistance = 80,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_SWLadder"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 9,
		PositionY = 2,
		PositionZ = 89,
		Name = "Anchor_SWLadder",
		Map = M._MAP,
		Resource = M["Anchor_SWLadder"]
	}
end

M["Ladder_Entrance"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 9,
		PositionY = 2,
		PositionZ = 87,
		Name = "Ladder_Entrance",
		Map = M._MAP,
		Resource = M["Ladder_Entrance"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["Ladder_Entrance"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromCavernSW",
		Map = ItsyScape.Resource.Map "Rumbridge_LeafyLake",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_Entrance"] {
		TravelAction
	}
end

M["Anchor_IslandLadder"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41,
		PositionY = 2,
		PositionZ = 51,
		Name = "Anchor_IslandLadder",
		Map = M._MAP,
		Resource = M["Anchor_IslandLadder"]
	}
end

M["Ladder_Island"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41,
		PositionY = 1,
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
		Anchor = "Anchor_IslandFromCavern",
		Map = ItsyScape.Resource.Map "Rumbridge_LeafyLake",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_Island"] {
		TravelAction
	}
end

M["Anchor_SELadder"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 89,
		PositionY = 0,
		PositionZ = 75,
		Name = "Anchor_SELadder",
		Map = M._MAP,
		Resource = M["Anchor_SELadder"]
	}
end

M["Ladder_SecretCorner"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 89,
		PositionY = 0,
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
		Anchor = "Anchor_FromCavernSE",
		Map = ItsyScape.Resource.Map "Rumbridge_LeafyLake",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_SecretCorner"] {
		TravelAction
	}
end

M["Door_SecretCorner"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 85,
		PositionY = 0,
		PositionZ = 73,
		RotationX = 0,
		RotationY = 0.707107,
		RotationZ = 0,
		RotationW = -0.707107,
		ScaleX = 1,
		ScaleY = 1,
		ScaleZ = 1,
		Name = "Door_SecretCorner",
		Map = M._MAP,
		Resource = M["Door_SecretCorner"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_IronGate",
		MapObject = M["Door_SecretCorner"]
	}

	M["Door_SecretCorner"] {
		ItsyScape.Action.Open() {
			Requirement {
				Resource = ItsyScape.Resource.Quest "MysteriousMachinations",
				Count = 1
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "MysteriousMachinations_XSteeleKey",
				Count = 1
			}
		},

		ItsyScape.Action.Close()
	}
end