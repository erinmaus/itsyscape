local M = include "Resources/Game/Maps/Rumbridge_Castle_Basement/DB/Default.lua"

ItsyScape.Meta.ResourceName {
	Value = "Rumbridge Castle, Basement",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "This would not pass a health inspection.",
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
		ColorGreen = 173,
		ColorBlue = 119,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.5,
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
		ColorRed = 20,
		ColorGreen = 20,
		ColorBlue = 20,
		NearDistance = 40,
		FarDistance = 80,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_FromKitchen"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 0,
		PositionZ = 27,
		Name = "Anchor_FromKitchen",
		Map = M._MAP,
		Resource = M["Anchor_FromKitchen"]
	}
end

M["Ladder_ToKitchen"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 0,
		PositionZ = 25,
		Name = "Ladder_ToKitchen",
		Map = M._MAP,
		Resource = M["Ladder_ToKitchen"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromBasement",
		Map = ItsyScape.Resource.Map "Rumbridge_Castle",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_ToKitchen"] {
		TravelAction
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["Ladder_ToKitchen"]
	}
end

M["BankChest"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 3,
		PositionY = 0,
		PositionZ = 1,
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

M["Chocoroach1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 0.5,
		PositionZ = 5,
		Name = "Chocoroach1",
		Map = M._MAP,
		Resource = M["Chocoroach1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chocoroach",
		MapObject = M["Chocoroach1"]
	}
end

M["Chocoroach2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19,
		PositionY = 0,
		PositionZ = 3,
		ScaleX = 0.5,
		ScaleY = 0.5,
		ScaleZ = 0.5,
		Name = "Chocoroach2",
		Map = M._MAP,
		Resource = M["Chocoroach2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chocoroach",
		MapObject = M["Chocoroach2"]
	}
end

M["Chocoroach3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 9,
		PositionY = 0,
		PositionZ = 19,
		ScaleX = 1.5,
		ScaleY = 1.5,
		ScaleZ = 1.5,
		Name = "Chocoroach3",
		Map = M._MAP,
		Resource = M["Chocoroach3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chocoroach",
		MapObject = M["Chocoroach3"]
	}
end

M["Chocoroach4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19,
		PositionY = 0,
		PositionZ = 19,
		ScaleX = 0.3,
		ScaleY = 0.3,
		ScaleZ = 0.3,
		Name = "Chocoroach4",
		Map = M._MAP,
		Resource = M["Chocoroach4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chocoroach",
		MapObject = M["Chocoroach4"]
	}
end

M["Chocoroach5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 5,
		PositionY = 0,
		PositionZ = 25,
		Name = "Chocoroach5",
		Map = M._MAP,
		Resource = M["Chocoroach5"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Chocoroach",
		MapObject = M["Chocoroach5"]
	}
end

