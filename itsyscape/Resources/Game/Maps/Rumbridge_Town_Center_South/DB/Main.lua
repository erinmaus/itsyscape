local M = include "Resources/Game/Maps/Rumbridge_Town_Center_South/DB/Default.lua"

ItsyScape.Meta.ResourceName {
	Value = "Rumbridge City Center, Shade District",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "The weirder part of Rumbridge.",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Rumbridge_Town_Center_South.Peep",
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
		ColorRed = 33,
		ColorGreen = 162,
		ColorBlue = 234,
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
		ColorRed = 234,
		ColorGreen = 162,
		ColorBlue = 33,
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
		ColorRed = 33,
		ColorGreen = 162,
		ColorBlue = 234,
		NearDistance = 50,
		FarDistance = 200,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_FromNorth"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 4,
		PositionZ = 7,
		Name = "Anchor_FromNorth",
		Map = M._MAP,
		Resource = M["Anchor_FromNorth"]
	}
end

M["Portal_ToNorth"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 4,
		PositionZ = 3,
		Name = "Portal_ToNorth",
		Map = M._MAP,
		Resource = M["Portal_ToNorth"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 6,
		SizeY = 2,
		SizeZ = 2,
		MapObject = M["Portal_ToNorth"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_ToNorth"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rumbridge City Center",
		Language = "en-US",
		Resource = M["Portal_ToNorth"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromSouth",
		Map = ItsyScape.Resource.Map "Rumbridge_Town_Center",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Enter",
		XProgressive = "Entering",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_ToNorth"] {
		TravelAction
	}
end

M["Anchor_FromEast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 61,
		PositionY = 4,
		PositionZ = 29,
		Name = "Anchor_FromEast",
		Map = M._MAP,
		Resource = M["Anchor_FromEast"]
	}
end

M["Portal_ToEast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 61,
		PositionY = 4,
		PositionZ = 29,
		Name = "Portal_ToEast",
		Map = M._MAP,
		Resource = M["Portal_ToEast"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 6,
		SizeY = 2,
		SizeZ = 2,
		MapObject = M["Portal_ToEast"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_ToEast"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rumbridge City Center, East",
		Language = "en-US",
		Resource = M["Portal_ToEast"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromShade",
		Map = ItsyScape.Resource.Map "Rumbridge_Town_Homes",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Enter",
		XProgressive = "Entering",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_ToEast"] {
		TravelAction
	}
end

M["Banker"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 17,
		PositionY = 4,
		PositionZ = 25,
		Name = "Banker",
		Map = M._MAP,
		Resource = M["Banker"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "FancyBanker_Default",
		MapObject = M["Banker"]
	}
end

M["Anchor_Oliver"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 4,
		PositionZ = 49,
		Direction = 1,
		Name = "Anchor_Oliver",
		Map = M._MAP,
		Resource = M["Anchor_Oliver"]
	}
end

M["Oliver"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Oliver",
		Map = M._MAP,
		Resource = M["Oliver"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Oliver",
		MapObject = M["Oliver"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Rumbridge_Town_Center_South/Scripts/Oliver_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Oliver"]
	}

	M["Oliver"] {
		ItsyScape.Action.Pet()
	}
end

M["Anchor_Lyra"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 4,
		PositionZ = 47,
		Direction = 1,
		Name = "Anchor_Lyra",
		Map = M._MAP,
		Resource = M["Anchor_Lyra"]
	}
end

M["Lyra"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Lyra",
		Map = M._MAP,
		Resource = M["Lyra"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Lyra",
		MapObject = M["Lyra"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Lyra"],
		Name = "Lyra",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Oliver"],
		Name = "Oliver",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Rumbridge_Town_Center_South/Dialog/Lyra_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["Lyra"] {
		TalkAction
	}
end

M["Coffin"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 4,
		PositionZ = 51,
		Name = "Coffin",
		Map = M._MAP,
		Resource = M["Coffin"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Coffin_Plain1",
		MapObject = M["Coffin"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Coffin"],
		Name = "Coffin",
		Action = TalkAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Search",
		XProgressive = "Searching",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Rumbridge_Town_Center_South/Dialog/Coffin_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["Coffin"] {
		TalkAction
	}
end
