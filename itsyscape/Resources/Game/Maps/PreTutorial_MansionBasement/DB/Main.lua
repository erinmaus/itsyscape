local M = include "Resources/Game/Maps/PreTutorial_MansionBasement/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.PreTutorial_MansionBasement.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Azathoth, Haunted Mansion, Basement",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Full of rats and perhaps other horrors...",
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
		ColorRed = 101,
		ColorGreen = 139,
		ColorBlue = 131,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.4,
		Resource = M["Light_Ambient"]
	}
end

M["Light_Fog1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Fog1",
		Map = M._MAP,
		Resource = M["Light_Fog1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Fog_Default",
		MapObject = M["Light_Fog1"]
	}

	ItsyScape.Meta.Fog {
		ColorRed = 91,
		ColorGreen = 119,
		ColorBlue = 111,
		NearDistance = 30,
		FarDistance = 60,
		Resource = M["Light_Fog1"]
	}
end

M["Light_Fog2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Fog2",
		Map = M._MAP,
		Resource = M["Light_Fog2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Fog_Default",
		MapObject = M["Light_Fog2"]
	}

	ItsyScape.Meta.Fog {
		ColorRed = 178,
		ColorGreen = 70,
		ColorBlue = 49,
		NearDistance = 50,
		FarDistance = 100,
		Resource = M["Light_Fog2"]
	}
end

M["Portal_UpStairs"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 1,
		PositionZ = 9,
		Name = "Portal_UpStairs",
		Map = M._MAP,
		Resource = M["Portal_UpStairs"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 5.5,
		SizeY = 8,
		SizeZ = 9.5,
		MapObject = M["Portal_UpStairs"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_UpStairs"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Floor 1",
		Language = "en-US",
		Resource = M["Portal_UpStairs"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromBasement",
		Map = ItsyScape.Resource.Map "PreTutorial_MansionFloor1",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Walk-up",
		XProgressive = "Walking-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_UpStairs"] {
		TravelAction
	}
end

M["Anchor_FromUpstairs"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21,
		PositionY = 1,
		PositionZ = 13,
		Name = "Anchor_FromUpstairs",
		Map = M._MAP,
		Resource = M["Anchor_FromUpstairs"]
	}
end

M["Rat1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 2,
		PositionZ = 21,
		Name = "Rat1",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Rat1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PreTutorial_Rat",
		MapObject = M["Rat1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/PreTutorial/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Rat1"]
	}
end

M["Rat2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19,
		PositionY = 1,
		PositionZ = 11,
		Name = "Rat2",
		Direction = 1,
		Map = M._MAP,
		Resource = M["Rat2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PreTutorial_Rat",
		MapObject = M["Rat2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/PreTutorial/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Rat2"]
	}
end

M["Rat3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 13,
		PositionY = 3,
		PositionZ = 13,
		Name = "Rat3",
		Direction = 1,
		Map = M._MAP,
		Resource = M["Rat3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PreTutorial_Rat",
		MapObject = M["Rat3"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/PreTutorial/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Rat3"]
	}
end

do
	ItsyScape.Meta.KeyItemLocationHint {
		Map = M._MAP,
		MapObject = M["CopperRock1"],
		KeyItem = ItsyScape.Resource.KeyItem "PreTutorial_MineCopper"
	}
end
