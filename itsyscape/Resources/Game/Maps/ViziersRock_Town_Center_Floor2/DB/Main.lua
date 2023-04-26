local M = include "Resources/Game/Maps/ViziersRock_Town_Center_Floor2/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.ViziersRock_Town_Center_Floor2.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Vizier's Rock City Center, Floor 2",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Can't escape the smog!",
	Language = "en-US",
	Resource = M._MAP
}

M["Anchor_FromBank"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 0,
		PositionZ = 53,
		Name = "Anchor_FromBank",
		Map = M._MAP,
		Resource = M["Anchor_FromBank"]
	}
end

M["Anchor_FromPub"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 53,
		PositionY = 0,
		PositionZ = 57,
		Name = "Anchor_FromPub",
		Map = M._MAP,
		Resource = M["Anchor_FromPub"]
	}
end

M["Ladder_Pub"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 55,
		PositionY = 0,
		PositionZ = 57,
		Name = "Ladder_Pub",
		Map = M._MAP,
		Resource = M["Ladder_Pub"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["Ladder_Pub"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromPubFloor2",
		Map = ItsyScape.Resource.Map "ViziersRock_Town_Center",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		XProgressive = "Climbing-down",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_Pub"] {
		TravelAction
	}
end

M["Portal_Bank"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 0,
		PositionZ = 55,
		Name = "Portal_Bank",
		Map = M._MAP,
		Resource = M["Portal_Bank"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 5.5,
		SizeY = 4,
		SizeZ = 5.5,
		MapObject = M["Portal_Bank"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_Bank"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Floor 1",
		Language = "en-US",
		Resource = M["Portal_Bank"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromBankFloor2",
		Map = ItsyScape.Resource.Map "ViziersRock_Town_Center",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Walk-down",
		XProgressive = "Walking-down",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_Bank"] {
		TravelAction
	}
end
