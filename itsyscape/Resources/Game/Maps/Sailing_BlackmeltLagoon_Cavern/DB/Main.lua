local M = include "Resources/Game/Maps/Sailing_BlackmeltLagoon_Cavern/DB/Default.lua"

ItsyScape.Meta.ResourceName {
	Value = "Pirate Cavern, Blackmelt Lagoon",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "A cache for the Black Tentacle.",
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
		ColorRed = 255,
		ColorGreen = 102,
		ColorBlue = 0,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.6,
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
		ColorRed = 255,
		ColorGreen = 204,
		ColorBlue = 0,
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
		ColorRed = 255,
		ColorGreen = 102,
		ColorBlue = 0,
		NearDistance = 50,
		FarDistance = 100,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_FromBlackmeltLagoon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 51,
		PositionY = 2.5,
		PositionZ = 53,
		Name = "Anchor_FromBlackmeltLagoon",
		Map = M._MAP,
		Resource = M["Anchor_FromBlackmeltLagoon"]
	}
end

M["Ladder_ToBlackmeltLagoon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 51,
		PositionY = 3,
		PositionZ = 51,
		Name = "Ladder_ToBlackmeltLagoon",
		Map = M._MAP,
		Resource = M["Ladder_ToBlackmeltLagoon"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["Ladder_ToBlackmeltLagoon"]
	}
end

M["Anchor_ToMainCavern_Top"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 49,
		PositionY = 6,
		PositionZ = 39,
		Name = "Anchor_ToMainCavern_Top",
		Map = M._MAP,
		Resource = M["Anchor_ToMainCavern_Top"]
	}
end

M["Anchor_ToMainCavern_Bottom"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 53,
		PositionY = 3,
		PositionZ = 39,
		Name = "Anchor_ToMainCavern_Bottom",
		Map = M._MAP,
		Resource = M["Anchor_ToMainCavern_Bottom"]
	}
end

M["Ladder_ToMainCavern"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 51.000000,
		PositionY = 3.000000,
		PositionZ = 39.000000,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = 0.707107,
		ScaleX = 1.000000,
		ScaleY = 1.000000,
		ScaleZ = 1.000000,
		Name = "Ladder_ToMainCavern",
		Map = M._MAP,
		Resource = M["Ladder_ToMainCavern"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["Ladder_ToMainCavern"]
	}

	local TravelUpAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_ToMainCavern_Top",
		Map = ItsyScape.Resource.Map "Sailing_BlackmeltLagoon_Cavern",
		Action = TravelUpAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		Language = "en-US",
		Action = TravelUpAction
	}

	local TravelDownAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_ToMainCavern_Bottom",
		Map = ItsyScape.Resource.Map "Sailing_BlackmeltLagoon_Cavern",
		Action = TravelDownAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		Language = "en-US",
		Action = TravelDownAction
	}

	M["Ladder_ToMainCavern"] {
		TravelUpAction,
		TravelDownAction
	}
end

M["Ladder_FromMainCavern"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37.000000,
		PositionY = 3.250000,
		PositionZ = 43.000000,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = -0.707107,
		Name = "Ladder_FromMainCavern",
		Map = M._MAP,
		Resource = M["Ladder_FromMainCavern"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["Ladder_FromMainCavern"]
	}

	local TravelUpAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromMainCavern_Top",
		Map = ItsyScape.Resource.Map "Sailing_BlackmeltLagoon_Cavern",
		Action = TravelUpAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		Language = "en-US",
		Action = TravelUpAction
	}

	local TravelDownAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromMainCavern_Bottom",
		Map = ItsyScape.Resource.Map "Sailing_BlackmeltLagoon_Cavern",
		Action = TravelDownAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		Language = "en-US",
		Action = TravelDownAction
	}

	M["Ladder_FromMainCavern"] {
		TravelUpAction,
		TravelDownAction
	}
end

M["Anchor_FromMainCavern_Top"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 6,
		PositionZ = 43,
		Name = "Anchor_FromMainCavern_Top",
		Map = M._MAP,
		Resource = M["Anchor_FromMainCavern_Top"]
	}
end

M["Anchor_FromMainCavern_Bottom"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 4,
		PositionZ = 43,
		Name = "Anchor_FromMainCavern_Bottom",
		Map = M._MAP,
		Resource = M["Anchor_FromMainCavern_Bottom"]
	}
end

M["Crate_SeaBass1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 9,
		PositionY = 4,
		PositionZ = 9,
		Name = "Crate_SeaBass1",
		Map = M._MAP,
		Resource = M["Crate_SeaBass1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_SeaBass1"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Sailing_BlackmeltLagoon_Cavern/Dialog/SeaBassCrate_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Search",
		Language = "en-US",
		Action = TalkAction
	}

	M["Crate_SeaBass1"] {
		TalkAction
	}
end

M["Crate_SeaBass2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 9,
		PositionY = 4,
		PositionZ = 11,
		Name = "Crate_SeaBass2",
		Map = M._MAP,
		Resource = M["Crate_SeaBass2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["Crate_SeaBass2"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Sailing_BlackmeltLagoon_Cavern/Dialog/SeaBassCrate_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Search",
		Language = "en-US",
		Action = TalkAction
	}

	M["Crate_SeaBass2"] {
		TalkAction
	}
end
