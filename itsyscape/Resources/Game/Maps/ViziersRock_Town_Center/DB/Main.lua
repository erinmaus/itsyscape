local M = include "Resources/Game/Maps/ViziersRock_Town_Center/DB/Default.lua"

ItsyScape.Meta.ResourceName {
	Value = "Vizier's Rock City Center",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Lots of smog...",
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
		ColorGreen = 55,
		ColorBlue = 200,
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
		ColorRed = 111,
		ColorGreen = 124,
		ColorBlue = 145,
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
		ColorGreen = 89,
		ColorBlue = 120,
		NearDistance = 30,
		FarDistance = 50,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_Teleport"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 4,
		PositionZ = 15,
		Name = "Anchor_Teleport",
		Map = M._MAP,
		Resource = M["Anchor_Teleport"]
	}
end

M["GeneralStoreOwner"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 4,
		PositionZ = 29,
		Direction = 1,
		Name = "GeneralStoreOwner",
		Map = M._MAP,
		Resource = M["GeneralStoreOwner"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "GeneralStoreOwner_Standard",
		MapObject = M["GeneralStoreOwner"]
	}
end

M["Steve"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19,
		PositionY = 4,
		PositionZ = 31,
		Direction = 1,
		Name = "Steve",
		Map = M._MAP,
		Resource = M["Steve"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Crafter_Steve",
		MapObject = M["Steve"]
	}
end

M["Bartender"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 4,
		PositionZ = 43,
		Direction = 1,
		Name = "Bartender",
		Map = M._MAP,
		Resource = M["Bartender"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Bartender_Robert",
		MapObject = M["Bartender"]
	}
end

M["Banker"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 11,
		PositionY = 4,
		PositionZ = 45,
		Name = "Banker",
		Map = M._MAP,
		Resource = M["Banker"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "FancyBanker_Default",
		MapObject = M["Banker"]
	}
end

M["BankChest1"] {
	ItsyScape.Action.Bank()
}

M["BankChest2"] {
	ItsyScape.Action.Bank()
}
